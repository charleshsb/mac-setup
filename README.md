# mac-setup

Dépôt privé: de quoi remettre un Mac neuf dans l'état de travail, sans secret.

```
mac-setup/
├── zshrc                  configuration zsh générique (oh-my-zsh, rbenv, nvm, postgres, ...)
├── zshrc.local.example    modèle de ~/.zshrc.local (tokens, alias de travail): jamais de valeurs
├── Brewfile               outils en ligne de commande et applications (casks)
└── install.sh             Homebrew, brew bundle, oh-my-zsh, liens (--dry-run disponible)
```

## Sur un Mac neuf

```bash
gh repo clone charleshsb/mac-setup ~/Code/mac-setup
cd ~/Code/mac-setup
./install.sh --dry-run
./install.sh
```

Puis: remplir `~/.zshrc.local` (modèle dans `zshrc.local.example`), et lancer
`~/Code/ai-harness/install.sh` pour l'environnement Claude Code.

## Règle d'or: les secrets

`zshrc` est versionné, donc **aucune valeur sensible dedans**: ni token, ni clé, ni identifiant de
projet cloud, ni nom d'employeur ou de collègue. Tout cela va dans `~/.zshrc.local`, ignoré par
git (`.gitignore`). Ces valeurs se régénèrent ou se retrouvent chez leur service: rien à sauvegarder ici.

## À faire à la main

Non couverts par le script: `nvm` (et les versions de Node), le SDK
Google Cloud (`~/google-cloud-sdk`), `bun`.
