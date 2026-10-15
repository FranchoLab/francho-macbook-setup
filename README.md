# francho-macbook-setup

A reusable, documented starting point for rebuilding a macOS development environment. Homebrew installs the tools and applications; the repository provides a small set of portable shell, Git, terminal, and Visual Studio Code defaults.

The setup is designed for recent macOS releases and Apple Silicon. It avoids private machine state: no credentials, SSH keys, tokens, company settings, or exported Raycast configuration belong here.

## Philosophy

- **Reproducible:** declare packages in `Brewfile` and editor extensions in `vscode/extensions.txt`.
- **Portable:** use public tools and neutral defaults; personalize machine-specific details locally.
- **Understandable:** keep configuration small, documented, and easy to change.
- **Safe to rerun:** package installation and symlink setup can be repeated. Existing files that are not links to this repository are backed up, not overwritten.
- **No shell framework:** Zsh is configured directly, without Oh My Zsh.

## What's included

- CLI tools: GitHub CLI, Azure CLI, jq/yq, ripgrep, fd, eza, bat, fzf, lazygit, delta, mise, Starship, PowerShell, and Zsh plugins. Podman and `podman compose` are used but installed separately following the official macOS instructions.
- Applications: Visual Studio Code, Ghostty, Raycast, Rectangle, Firefox, Google Chrome, and Obsidian.
- Portable defaults for Zsh, Starship, Git, Ghostty, and VS Code.
- Setup, tool reference, daily cheatsheet, and validation scripts.

See [docs/tools.md](docs/tools.md) for descriptions and examples.

## Prerequisites

- A recent macOS release and an administrator account.
- Internet access for Homebrew and package downloads.
- Apple's Command Line Tools. If they are missing, run `xcode-select --install` and complete the prompt before bootstrapping.
- For VS Code extension installation, the `code` command must be available. See [docs/setup.md](docs/setup.md#make-the-code-command-available) if it is not.

`bootstrap.sh` installs Homebrew when it is missing, then installs the declared packages. Homebrew's official installer may request administrator approval.

## Quick start

```sh
git clone https://github.com/<your-github-username>/francho-macbook-setup.git
cd francho-macbook-setup
./bootstrap.sh
```

Review the files before running them if you are adapting this repository. The bootstrap script changes files in your home directory by creating symlinks; existing regular files are moved to timestamped backups first.

## Complete setup

1. Follow [docs/setup.md](docs/setup.md) on a new Mac.
2. Run `./bootstrap.sh`.
3. Restart Terminal (or start a new shell), sign in to any tools that need authentication, and configure Raycast manually using [docs/setup.md](docs/setup.md#raycast).
4. Run `./scripts/verify-setup.sh` to check the installed commands.
5. Review [docs/cheatsheet.md](docs/cheatsheet.md) for everyday examples.

The bootstrap does not install Podman or its Compose support, authenticate `gh` or `az`, create or start a Podman machine, or export/import private application data.

## Repository structure

```text
francho-macbook-setup/
├── README.md
├── Brewfile
├── bootstrap.sh
├── zsh/
│   └── .zshrc
├── starship/
│   └── starship.toml
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── ghostty/
│   └── config
├── vscode/
│   ├── settings.json
│   └── extensions.txt
├── docs/
│   ├── setup.md
│   ├── tools.md
│   └── cheatsheet.md
└── scripts/
    ├── install-vscode-extensions.sh
    └── verify-setup.sh
```

Ghostty's configuration is provided as a reference; copy it into Ghostty's user configuration directory if you want to activate it. Application-specific settings are not linked or copied automatically.

## Updating the environment

Pull the latest repository changes, then rerun:

```sh
brew update
./bootstrap.sh
```

Add or remove Homebrew packages in `Brewfile`, VS Code extensions in `vscode/extensions.txt`, and configuration in the corresponding directory. Review and test changes before publishing. For a package-only refresh, run `brew bundle --file="$PWD/Brewfile"`.

## Troubleshooting

- **Homebrew cannot install:** check internet access, complete `xcode-select --install`, then retry. Review Homebrew's diagnostic output before changing permissions.
- **`code` not found:** open VS Code, run **Shell Command: Install 'code' command in PATH** from the Command Palette, open a new terminal, and retry the extension script.
- **A config link already exists:** the script backs up ordinary files and replaces symlinks; inspect timestamped backups in your home directory if you need to restore local content.
- **Shell plugin is missing:** rerun `brew bundle --file="$PWD/Brewfile"` and open a new terminal.
- **Podman commands cannot connect:** on macOS, Podman runs inside a virtual machine. Initialize it once with `podman machine init`, then start it with `podman machine start`.
- **`podman compose` is unavailable:** verify that the official Podman installation and Compose support were installed according to the [official macOS instructions](https://podman.io/docs/installation#macos). This repository does not install either component through Homebrew.
- **Azure or GitHub CLI asks to sign in:** authenticate interactively with `az login` or `gh auth login`. Never place access tokens in this repository.

## Roadmap

- Add opt-in, independently runnable setup modules for additional developer tools.
- Add automated shell/configuration checks to continuous integration.
- Document optional macOS preferences without applying invasive system defaults automatically.
- Add more platform-aware validation as the supported macOS range evolves.

## Security

Keep credentials and machine-specific data out of this public repository. Use each tool's secure login flow and local credential store. Before contributing, inspect staged changes and ensure there are no private URLs, account details, tokens, or exported application settings.
