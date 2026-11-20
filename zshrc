# Generic shell setup, versioned. Machine- and employer-specific settings (tokens, project
# ids, work aliases) live in ~/.zshrc.local, which is never committed: see zshrc.local.example.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git bundler rake ruby npm)

# Completions must be on fpath before oh-my-zsh runs compinit.
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)

source "$ZSH/oh-my-zsh.sh"

export LANG=en_US.UTF-8

alias separator="printf '=%.0s' {1..100} ; printf '\n'"
alias reload="source ~/.zshrc && hash -r"

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ruby
export PATH="$HOME/.rbenv/shims:$PATH"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# PostgreSQL
# Newest installed PostgreSQL: numeric glob sort, so @18 sorts after @9.
() {
  setopt local_options numeric_glob_sort
  local pg_bin=(/opt/homebrew/opt/postgresql@*/bin(N[-1]))
  [ -n "$pg_bin" ] && export PATH="$pg_bin:$PATH"
}
export PGHOST=localhost
export PGGSSENCMODE="disable"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Google Cloud SDK
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/bin"  # Docker Desktop CLI; not always in the PATH of GUI-launched shells

typeset -U path PATH  # drop duplicate entries

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# These two come last: syntax highlighting has to see everything defined above.
for prefix in /opt/homebrew /usr/local; do
  [ -f "$prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] \
    && source "$prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] \
    && source "$prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
done
