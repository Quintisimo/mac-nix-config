# Mac Nix Config

- Install nix using `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`

- Clone the repo into `/etc/nix-darwin`

- Setup nix-darwin using `sudo nix run nix-darwin/master#darwin-rebuild -- switch`

- Apply chnages using `sudo darwin-rebuild switch`
