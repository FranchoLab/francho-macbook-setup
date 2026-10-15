#!/usr/bin/env bash

set -u

readonly COLOR_GREEN=$'\033[0;32m'
readonly COLOR_RED=$'\033[0;31m'
readonly COLOR_RESET=$'\033[0m'

declare -a missing_tools=()

check_tool() {
  local tool_name="$1"
  local executable_name="$2"

  if command -v "${executable_name}" >/dev/null 2>&1; then
    printf '%s[PASS]%s %s (%s)\n' "${COLOR_GREEN}" "${COLOR_RESET}" "${tool_name}" "$(command -v "${executable_name}")"
  else
    printf '%s[FAIL]%s %s (%s no encontrado)\n' "${COLOR_RED}" "${COLOR_RESET}" "${tool_name}" "${executable_name}"
    missing_tools+=("${tool_name}")
  fi
}

check_code_cli() {
  local code_path=""
  if command -v code >/dev/null 2>&1; then
    code_path="$(command -v code)"
  elif [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
    code_path="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  elif [[ -x "${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
    code_path="${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  fi

  if [[ -n "${code_path}" ]]; then
    printf '%s[PASS]%s Visual Studio Code CLI (%s)\n' "${COLOR_GREEN}" "${COLOR_RESET}" "${code_path}"
  else
    printf '%s[FAIL]%s Visual Studio Code CLI (code no encontrado)\n' "${COLOR_RED}" "${COLOR_RESET}"
    missing_tools+=("Visual Studio Code CLI")
  fi
}

main() {
  printf 'Verificación del entorno de desarrollo\n\n'
  check_tool "Homebrew" "brew"
  check_tool "Git" "git"
  check_tool "GitHub CLI" "gh"
  check_tool "Azure CLI" "az"
  check_tool "Podman" "podman"
  check_tool "mise" "mise"
  check_code_cli

  printf '\n'
  if ((${#missing_tools[@]} == 0)); then
    printf '%sTodas las herramientas verificadas están disponibles.%s\n' "${COLOR_GREEN}" "${COLOR_RESET}"
    return 0
  fi

  printf '%sFaltan %d herramienta(s): %s%s\n' \
    "${COLOR_RED}" "${#missing_tools[@]}" "${missing_tools[*]}" "${COLOR_RESET}" >&2
  return 1
}

main "$@"
