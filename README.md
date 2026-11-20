# mac-setup

Everything needed to bring a fresh Mac to a working state, with no secrets in it.

```
mac-setup/
├── zshrc                  generic zsh configuration (oh-my-zsh, rbenv, nvm, postgres, ...)
├── zshrc.local.example    template for ~/.zshrc.local (tokens, work aliases): never any values
├── Brewfile               command-line tools and applications (casks)
└── install.sh             Homebrew, brew bundle, nvm and Node, oh-my-zsh, links (--dry-run available)
```

## On a fresh Mac

If the repository is private, cloning it already requires GitHub authentication, hence the order:
Xcode CLT, Homebrew, `gh`, login, then clone.

```bash
xcode-select --install                        # wait for the installer to finish
# Homebrew: official installer at https://brew.sh
brew install gh
gh auth login --git-protocol ssh --web        # generates and uploads the SSH key
gh repo clone charleshsb/mac-setup ~/Code/mac-setup
cd ~/Code/mac-setup
./install.sh --dry-run
./install.sh
gh auth status                                # check
```

`install.sh` runs the `gh` login again if it is missing, and asks for git `user.name` /
`user.email` when they are absent from the global config (nothing is overwritten, no default
value lives in this repository).

Then: fill in `~/.zshrc.local` (template in `zshrc.local.example`), and run
`~/Code/ai-harness/install.sh` to set up the Claude Code environment.

## Golden rule: secrets

`zshrc` is versioned, so it holds **no sensitive value**: no token, no key, no cloud project id,
no employer or colleague name. All of that goes in `~/.zshrc.local`, ignored by git
(`.gitignore`). Those values can be regenerated or looked up at their source: nothing to back up here.

## By hand

Not covered by the script: the Google Cloud SDK (`~/google-cloud-sdk`), `bun`.
