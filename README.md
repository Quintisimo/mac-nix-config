# Mac Nix Config

- Install nix using `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`

- Add ssh key to `~/.ssh`

- Clone the repo into `/etc/nix-darwin`

- Setup nix-darwin using `sudo nix run nix-darwin/master#darwin-rebuild -- switch`

- Apply chnages using `sudo darwin-rebuild switch`

## Adding/Editing secrets

- Change into the secrets folder using `cd secrets`
 
- Run the command `nix run github:ryantm/agenix -- -e secrets.age`
