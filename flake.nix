{
  description = "Macbook Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-mssql = {
      url = "github:microsoft/homebrew-mssql-release";
      flake = false;
    };
    homebrew-functions = {
      url = "github:azure/homebrew-functions";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      nix-darwin,
      mac-app-util,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-mssql,
      homebrew-functions,
      home-manager,
      agenix,
      ...
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macbook
      darwinConfigurations."macbook" =
        let
          username = "quintisimo";
          home = "/Users/${username}";
        in
        nix-darwin.lib.darwinSystem {
          modules = [
            ./config.nix
            {
              username = username;
              home = home;
              font = "Maple Mono NF CN";
            }
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
                  "azure/homebrew-functions" = homebrew-functions;
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
