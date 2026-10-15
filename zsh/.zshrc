# Keep interactive shell startup quick and predictable.
export PATH="${PATH}:${HOME}/.local/bin"

# Use a larger, duplicate-aware history shared between shell sessions.
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Use Homebrew's prefix when available; this supports Apple Silicon and Intel Macs.
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"

  # Load the lightweight plugins installed by Homebrew, if present.
  [[ -r "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
    && source "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

fi

# Enable fzf's key bindings and completion for the installed fzf version.
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Start Starship only in interactive shells.
if [[ -o interactive ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Syntax highlighting should be sourced after other plugins and shell integrations.
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
  [[ -r "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
    && source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Handy replacements with readable defaults.
alias ls="eza"
alias ll="eza -la"
alias la="eza -la"
alias cat="bat"
alias ..="cd .."
alias ...="cd ../.."
alias g="git"
alias lg="lazygit"
