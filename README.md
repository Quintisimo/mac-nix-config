# Mac Nix Config

- Install nix using `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`

- Clone the repo into `~/.config/nix`

- Setup nix-darwin using `sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix`

- Apply chnages using `sudo darwin-rebuild --flake ~/.config/nix switch`
