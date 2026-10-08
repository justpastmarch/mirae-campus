#!/usr/bin/env bash
set -euo pipefail

node_ready() {
  command -v node >/dev/null && command -v npm >/dev/null &&
    node -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>22||(a===22&&b>=12)?0:1)'
}
python_ready() {
  python3 -c 'import sys,venv,ensurepip; sys.exit(0 if sys.version_info >= (3,10) else 1)' >/dev/null 2>&1
}
if [[ "${1:-}" == '--check' ]]; then
  if ! node_ready || ! python_ready || ! command -v git >/dev/null; then
    echo 'Required programs are missing.' >&2
    exit 1
  fi
  echo 'Node, npm, Python, venv and Git are ready.'
  exit 0
fi

case "$(uname -s)" in
  Darwin)
    if ! node_ready || ! python_ready || ! command -v git >/dev/null; then
      if ! command -v brew >/dev/null; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
          eval "$(/usr/local/bin/brew shellenv)"
        else
          brew_installer=$(mktemp)
          curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brew_installer"
          /bin/bash "$brew_installer"
          if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          else
            eval "$(/usr/local/bin/brew shellenv)"
          fi
        fi
      fi
      if ! node_ready; then
        brew install node@22
        export PATH="$(brew --prefix node@22)/bin:$PATH"
      fi
      if ! python_ready; then
        brew install python@3.13
        export PATH="$(brew --prefix python@3.13)/libexec/bin:$PATH"
      fi
      if ! command -v git >/dev/null; then brew install git; fi
    fi
    ;;
  Linux)
    if ! command -v apt-get >/dev/null; then
      echo 'Automatic installation supports Ubuntu 22.04+ and Debian 12+.' >&2
      exit 1
    fi
    if ! node_ready || ! python_ready || ! command -v git >/dev/null; then
      sudo apt-get update
      sudo apt-get install -y ca-certificates curl git python3 python3-venv python3-pip
      if ! node_ready; then
        node_installer=$(mktemp)
        curl -fsSL https://deb.nodesource.com/setup_22.x -o "$node_installer"
        sudo bash "$node_installer"
        sudo apt-get install -y nodejs
      fi
    fi
    ;;
  *) echo 'Use bootstrap.ps1 on Windows.' >&2; exit 1 ;;
esac

if ! node_ready || ! python_ready || ! command -v git >/dev/null; then
  echo 'Node >=22.12, npm, Python >=3.10 with venv, and Git are required.' >&2
  exit 1
fi
repo=https://github.com/justpastmarch/mirae-campus.git
target="$PWD/mirae-campus"
if [[ -e "$target" ]]; then
  if [[ ! -d "$target/.git" ]] || [[ "$(git -C "$target" remote get-url origin)" != "$repo" ]]; then
    echo 'mirae-campus already exists and is not this repository. Use another folder.' >&2
    exit 1
  fi
  if [[ -n "$(git -C "$target" status --porcelain)" ]]; then
    echo 'Local changes exist. Commit or move them before updating.' >&2
    exit 1
  fi
  if [[ "$(git -C "$target" branch --show-current)" != main ]]; then
    echo 'Switch this repository to main before updating.' >&2
    exit 1
  fi
  git -C "$target" pull --ff-only origin main
else
  git clone "$repo" "$target"
fi
cd "$target"
npm start
