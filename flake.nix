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
    agenix.url = "github:ryantm/agenix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew, homebrew-core, homebrew-cask, home-manager, agenix, nix-vscode-extensions }:
  let
    username = "quintisimo";
    homeDirectory = "/Users/${username}";
    configuration = { pkgs, config, ... }: {
      # Allow unfree software
      nixpkgs.config.allowUnfree = true;

      # Automatic garbage collection
      nix.gc.automatic = true;

      # Manage vscode extensions with nix
      nixpkgs.overlays = [
          nix-vscode-extensions.overlays.default
      ];

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = import ./packages/nix.nix { 
        inherit pkgs; 
      };

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
      ];  

      homebrew = {
        enable = true;
        taps = builtins.attrNames config.nix-homebrew.taps;
	      onActivation = {
	        cleanup = "zap";
        };
        casks = import ./packages/casks.nix;
	      masApps = import ./packages/mas.nix;
      };

      system = {
        # Set Git commit hash for darwin-version
        configurationRevision = self.rev or self.dirtyRev or null;
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 6;
        primaryUser = username;
        defaults = {
          # Dock Setup
          dock = import ./dock.nix { 
            inherit  pkgs;
            inherit homeDirectory;   
          };
          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            AppleIconAppearanceTheme = "RegularDark";
            # Set key repeat speed to fastest and delay key repeat to shortest
            InitialKeyRepeat = 15;
            KeyRepeat = 2;
          };
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXPreferredViewStyle = "Nlsv";
            NewWindowTarget = "Other";
            NewWindowTargetPath = "file://${homeDirectory}/Github";
            ShowPathbar = true;
            ShowStatusBar = true;
          };
        };
      };

      users = {
	      knownUsers = [username];
	      users.${username} = {
          name = username;
          uid = 501;
          home = homeDirectory;
          shell = pkgs.fish;
	      };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Add ability to used TouchID for sudo authentication
      security.pam.services.sudo_local.touchIdAuth = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
	      configuration
	      mac-app-util.darwinModules.default 
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
	        home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
            agenix.homeManagerModules.default
          ];
          home-manager.extraSpecialArgs = {
            inherit homeDirectory;
          };
          home-manager.users.${username} = ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
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
