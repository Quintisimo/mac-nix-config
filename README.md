# Nix Darwin

- Install nix how [nix-darwin recommends](https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#prerequisites)

- Install xcode command line tools using `xcode-select --install`

- Add ssh key to `~/.ssh`

- Clone the repo into `/etc/nix-darwin`

- Setup nix-darwin using `sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#CONFIG_NAME`

- Apply changes using `sudo darwin-rebuild switch --flake .#CONFIG_NAME`

## Adding/Editing secrets

- Change into the secrets folder using `cd secrets`

- Run the command `nix run github:ryantm/agenix -- -e secrets.age`

## Folder Icons

- Folder icons are created using:
  - https://folderart.christianvm.dev/
  - https://icon-sets.iconify.design/
