# Mac Nix Config

- Install nix using `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`

- Add ssh key to `~/.ssh`

- Clone the repo into `/etc/nix-darwin`

- Setup nix-darwin using `sudo nix run nix-darwin/master#darwin-rebuild -- switch`

- Apply changes using `sudo darwin-rebuild switch`

## Adding/Editing secrets

- Change into the secrets folder using `cd secrets`

- Run the command `nix run github:ryantm/agenix -- -e secrets.age`

## Folder Icons

- Folder icons are created using:
  - https://folderart.christianvm.dev/
  - https://icon-sets.iconify.design/

## Zen Browser Configuration

- Links depend on two containers being present `Work` and `Personal`
- Install [Open URL in Container](https://addons.mozilla.org/en-US/firefox/addon/open-url-in-container/) so that links can be opened in the correct container
