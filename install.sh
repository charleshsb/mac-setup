#!/usr/bin/env bash
# Set up a fresh Mac: Homebrew, the Brewfile, oh-my-zsh and the shell configuration.
#
#   ./install.sh            do everything
#   ./install.sh --dry-run  print what would change, change nothing
#
# Idempotent. An existing ~/.zshrc that is not already our link is moved to ~/.zshrc.bak
# (or .bak.1, .bak.2, ...) before linking. ~/.zshrc.local is created from the example only
# when absent, with mode 600, and never overwritten.
set -eu

root="$(cd "$(dirname "$0")" && pwd)"
dry_run=0
case "${1:-}" in
  "") ;;
  --dry-run) dry_run=1 ;;
  -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  *) echo "install: unknown option '$1'" >&2; exit 2 ;;
esac

say() { if [ "$dry_run" -eq 1 ]; then echo "[dry-run] $*"; else echo "$*"; fi; }

if ! xcode-select -p >/dev/null 2>&1; then
  say "Xcode command line tools missing: running xcode-select --install"
  if [ "$dry_run" -eq 0 ]; then
    xcode-select --install || true
    echo "Finish the Xcode installer, then run this script again." >&2
    exit 1
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  say "install Homebrew (official installer)"
  if [ "$dry_run" -eq 0 ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

say "brew bundle --file $root/Brewfile"
if [ "$dry_run" -eq 0 ]; then brew bundle --file "$root/Brewfile"; fi

# Preferred stack: latest stable Ruby as the global default (projects pin their own with
# .ruby-version), then the latest Rails.
if command -v rbenv >/dev/null 2>&1 || [ "$dry_run" -eq 1 ]; then
  if [ -z "$(ls "$HOME/.rbenv/versions" 2>/dev/null)" ]; then
    say "rbenv: install the latest stable Ruby, set it as global, gem install rails"
    if [ "$dry_run" -eq 0 ]; then
      ruby_version="$(rbenv install -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)"
      rbenv install "$ruby_version"
      rbenv global "$ruby_version"
      RBENV_VERSION="$ruby_version" rbenv exec gem install rails
    fi
  else
    say "ok      a Ruby is already installed under ~/.rbenv/versions, left alone"
  fi
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  say "install oh-my-zsh (official installer, keeps our .zshrc)"
  if [ "$dry_run" -eq 0 ]; then
    RUNZSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi

dest="$HOME/.zshrc"
if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$root/zshrc" ]; then
  say "ok      $dest already linked"
else
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup="$dest.bak"; n=0
    while [ -e "$backup" ] || [ -L "$backup" ]; do n=$((n + 1)); backup="$dest.bak.$n"; done
    say "backup  $dest -> $backup"
    if [ "$dry_run" -eq 0 ]; then mv "$dest" "$backup"; fi
  fi
  say "link    $dest -> $root/zshrc"
  if [ "$dry_run" -eq 0 ]; then ln -s "$root/zshrc" "$dest"; fi
fi

local_file="$HOME/.zshrc.local"
if [ -e "$local_file" ]; then
  say "ok      $local_file already exists, left alone"
else
  say "create  $local_file from zshrc.local.example (fill in your secrets)"
  if [ "$dry_run" -eq 0 ]; then
    cp "$root/zshrc.local.example" "$local_file"
    chmod 600 "$local_file"
  fi
fi

say "done. Next: fill in ~/.zshrc.local, then run ai-harness/install.sh"
