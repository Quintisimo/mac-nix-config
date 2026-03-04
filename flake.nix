{
  description = "Macbook Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    mac-app-util.url = "github:hraban/mac-app-util";
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-mssql = {
      url = "github:microsoft/homebrew-mssql-release";
      flake = false;
    };
    macos-gitignore = {
      url = "github:github/gitignore";
      flake = false;
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      agenix,
      mac-app-util,
      darwin-custom-icons,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-mssql,
      macos-gitignore,
      ...
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macbook
      darwinConfigurations."macbook" =
        let
          username = "quintisimo";
          home = "/Users/${username}";
          github = "${home}/Github";
        in
        nix-darwin.lib.darwinSystem {
          modules = [
            ./config.nix
            {
              username = username;
              font = "Maple Mono NF CN";
              home = home;
              folders = {
                github = github;
                downloads = "${home}/Downloads";
                personal = "${github}/personal";
                work = "${github}/work";
                nix = "/etc/nix-darwin";
              };
            }
            darwin-custom-icons.darwinModules.default
            mac-app-util.darwinModules.default
            agenix.nixosModules.default
            {
              age = {
                identityPaths = [ "${home}/.ssh/id_ed25519" ];
                secrets = {
                  fish_env = {
                    file = ./secrets/secrets.age;
                    owner = username;
                  };
                };
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit macos-gitignore; };
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
              home-manager.users."${username}" = ./home;
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = true;

                # User owning the Homebrew prefix
                user = username;

                # Optional: Declarative tap management
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "microsoft/homebrew-mssql" = homebrew-mssql;
                };

                # Optional: Enable fully-declarative tap management
                #
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                mutableTaps = false;
              };
            }
          ];
        };
    };
}
