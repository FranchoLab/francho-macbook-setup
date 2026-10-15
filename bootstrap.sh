#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly BREWFILE="${SCRIPT_DIR}/Brewfile"
readonly HOME_CONFIG_DIR="${HOME}/.config"

readonly COLOR_RESET=$'\033[0m'
readonly COLOR_BLUE=$'\033[0;34m'
readonly COLOR_GREEN=$'\033[0;32m'
readonly COLOR_YELLOW=$'\033[0;33m'
readonly COLOR_RED=$'\033[0;31m'

log_info() {
  printf '%s[INFO]%s %s\n' "${COLOR_BLUE}" "${COLOR_RESET}" "$*"
}

log_success() {
  printf '%s[ OK ]%s %s\n' "${COLOR_GREEN}" "${COLOR_RESET}" "$*"
}

log_warning() {
  printf '%s[WARN]%s %s\n' "${COLOR_YELLOW}" "${COLOR_RESET}" "$*"
}

log_error() {
  printf '%s[FAIL]%s %s\n' "${COLOR_RED}" "${COLOR_RESET}" "$*" >&2
}

die() {
  log_error "$*"
  exit 1
}

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '%s\n' /opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '%s\n' /usr/local/bin/brew
  else
    return 1
  fi
}

install_homebrew_if_needed() {
  if BREW_BIN="$(find_brew)"; then
    log_success "Homebrew ya está instalado: ${BREW_BIN}"
    return
  fi

  log_info "Homebrew no está instalado. Iniciando el instalador oficial."
  if ! command -v curl >/dev/null 2>&1; then
    die "No se encontró curl. Instala las Command Line Tools de Xcode y vuelve a intentarlo."
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || die "Falló la instalación de Homebrew."

  BREW_BIN="$(find_brew)" || die "Homebrew se instaló, pero no se encontró en PATH."
  eval "$("${BREW_BIN}" shellenv)"
  log_success "Homebrew instalado."
}

install_packages() {
  [[ -f "${BREWFILE}" ]] || die "No se encontró Brewfile en ${SCRIPT_DIR}."
  log_info "Instalando paquetes declarados en Brewfile (puede tardar unos minutos)..."
  "${BREW_BIN}" bundle --file="${BREWFILE}" || die "Homebrew Bundle no pudo completar la instalación."
  log_success "Paquetes instalados."
}

link_config() {
  local source_path="$1"
  local target_path="$2"

  [[ -f "${source_path}" ]] || die "No se encontró el archivo de configuración: ${source_path}"
  mkdir -p "$(dirname -- "${target_path}")"

  if [[ -L "${target_path}" ]] && [[ "$(readlink "${target_path}")" == "${source_path}" ]]; then
    log_success "Enlace ya actualizado: ${target_path}"
    return
  fi

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    local backup_path="${target_path}.backup.$(date +%Y%m%d%H%M%S)"
    mv -- "${target_path}" "${backup_path}" || die "No se pudo respaldar ${target_path}."
    log_warning "Se guardó el archivo existente en ${backup_path}"
  fi

  ln -s "${source_path}" "${target_path}" || die "No se pudo crear el enlace ${target_path}."
  log_success "Enlace creado: ${target_path}"
}

link_configs() {
  mkdir -p "${HOME_CONFIG_DIR}"
  link_config "${SCRIPT_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
  link_config "${SCRIPT_DIR}/git/.gitconfig" "${HOME}/.gitconfig"
  link_config "${SCRIPT_DIR}/git/.gitignore_global" "${HOME}/.gitignore_global"
  link_config "${SCRIPT_DIR}/starship/starship.toml" "${HOME_CONFIG_DIR}/starship.toml"
}

install_vscode_extensions() {
  local extension_installer="${SCRIPT_DIR}/scripts/install-vscode-extensions.sh"
  [[ -x "${extension_installer}" ]] || die "No se encontró el instalador ejecutable de extensiones de VS Code."
  "${extension_installer}" || die "No se pudieron instalar las extensiones de VS Code."
}

main() {
  log_info "Preparando el entorno de desarrollo para macOS..."
  install_homebrew_if_needed
  eval "$("${BREW_BIN}" shellenv)"
  install_packages
  link_configs
  install_vscode_extensions

  log_info "Validando las herramientas principales..."
  "${SCRIPT_DIR}/scripts/verify-setup.sh"
  log_success "Configuración completada. Abre una nueva terminal para cargar Zsh y Starship."
}

main "$@"
