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
    homebrew-vjeantet = {
      url = "github:vjeantet/homebrew-tap";
      flake = false;
    };
    macos-gitignore = {
      url = "github:github/gitignore";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      agenix,
      darwin-custom-icons,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-mssql,
      homebrew-vjeantet,
      macos-gitignore,
      ponytail,
      ...
    }:
    let
      darwinConfig =
        {
          username,
          email,
          isWork,
        }:
        let
          home = "/Users/${username}";
        in
        nix-darwin.lib.darwinSystem {
          modules = [
            ./config.nix
            {
              username = username;
              home = home;
              isWork = isWork;
            }
            darwin-custom-icons.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit macos-gitignore ponytail email; };
                users."${username}" = ./home;
              };
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

                trust.formulae = [
                  "microsoft/mssql/msodbcsql18"
                  "microsoft/mssql/mssql-tools18"
                  "vjeantet/tap/alerter"
                ];

                # Optional: Declarative tap management
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "microsoft/homebrew-mssql" = homebrew-mssql;
                  "vjeantet/homebrew-tap" = homebrew-vjeantet;
                };

                # Optional: Enable fully-declarative tap management
                #
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                mutableTaps = false;
              };
            }
          ]
          ++ (
            if isWork then
              [
                agenix.nixosModules.default
                {
                  age = {
                    identityPaths = [ "${home}/.ssh/id_ed25519" ];
                    secrets.fish_env = {
                      file = ./secrets/secrets.age;
                      owner = username;
                    };
                  };
                }
              ]
            else
              [ ]
          );
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#personal
      darwinConfigurations."personal" =
        let
          username = "quintisimo";
          email = "quintuscardozo13@gmail.com";
          isWork = false;
        in
        darwinConfig { inherit username email isWork; };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#work
      darwinConfigurations."work" =
        let
          username = "qcardozo";
          email = "qcardozo@getlegaltech.com";
          isWork = true;
        in
        darwinConfig { inherit username email isWork; };
    };
}
