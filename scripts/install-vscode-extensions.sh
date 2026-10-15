#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly EXTENSIONS_FILE="${SCRIPT_DIR}/../vscode/extensions.txt"

log_info() {
  printf '[INFO] %s\n' "$*"
}

log_success() {
  printf '[ OK ] %s\n' "$*"
}

log_error() {
  printf '[FAIL] %s\n' "$*" >&2
}

find_code_cli() {
  if command -v code >/dev/null 2>&1; then
    command -v code
  elif [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
    printf '%s\n' "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  elif [[ -x "${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
    printf '%s\n' "${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  else
    return 1
  fi
}

main() {
  [[ -f "${EXTENSIONS_FILE}" ]] || {
    log_error "No se encontró ${EXTENSIONS_FILE}."
    return 1
  }

  local code_cli
  if ! code_cli="$(find_code_cli)"; then
    log_error "No se encontró el comando 'code'. Abre VS Code y habilita 'Shell Command: Install code command in PATH'."
    return 1
  fi

  local extensions=()
  while IFS= read -r extension || [[ -n "${extension}" ]]; do
    [[ -z "${extension}" || "${extension}" == \#* ]] && continue
    extensions+=("${extension}")
  done < "${EXTENSIONS_FILE}"

  if ((${#extensions[@]} == 0)); then
    log_info "No hay extensiones para instalar."
    return 0
  fi

  local total="${#extensions[@]}"
  local index=0
  local extension
  for extension in "${extensions[@]}"; do
    ((index += 1))
    log_info "Instalando extensión ${index}/${total}: ${extension}"
    "${code_cli}" --install-extension "${extension}" --force || {
      log_error "Falló la instalación de ${extension}."
      return 1
    }
  done

  log_success "Se instalaron las ${total} extensiones declaradas."
}

main "$@"
