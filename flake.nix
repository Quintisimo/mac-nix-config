{
  description = "Macbook Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, nix-homebrew, homebrew-core, homebrew-cask, home-manager, nix-vscode-extensions }:
  let
    username = "quintisimo";
    homeDirectory = "/Users/${username}";
    configuration = { pkgs, ... }: {
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
      environment.systemPackages = with pkgs; [ 
	      # shell
	      fish
	      fishPlugins.hydro

	      # cli tools
        bat
        eza
        gh
        gh-poi
	      terminal-notifier
        azure-cli
        azure-functions-core-tools
        poetry
        nodejs_22
        pnpm

	      # applications
	      discord
	      the-unarchiver
	      _1password-gui
	      teams
	      slack
	      vscode
        maccy
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.space-mono
      ];  

      homebrew = {
	      enable = true;
	      onActivation = {
	        cleanup = "zap";
        };
        caskArgs = {
          appdir = "/Applications/Homebrew Apps";
        };
        casks = [
          "teamviewer"
          "ghostty"
          "zen"
          "orbstack"
          "wrike"
          "safeincloud-password-manager"
          "yaak"
	      ];
	      masApps = {
	        amphetamine = 937984704;
	        wifiman = 1385561119;
	      };
      };

      # Dock Setup
      system = {
        defaults = {
          dock = {
            show-recents = false;
            persistent-apps = [
              {
                app = "${pkgs.vscode.outPath}/Applications/Visual Studio Code.app";
              }
              {
                app = "/Applications/Homebrew Apps/Ghostty.app";
              }
              {
                app = "/Applications/Homebrew Apps/OrbStack.app";
              }
              {
                spacer = {
                  small = true;
                };
              }
              {
                app = "${pkgs.discord.outPath}/Applications/Discord.app";
              }
              {
                app = "${pkgs.slack.outPath}/Applications/Slack.app";
              }
              {
                app = "${pkgs.teams.outPath}/Applications/Teams.app";
              }
              {
                app = "/Applications/Homebrew Apps/Wrike for Mac.app";
              }
              {
                spacer = {
                  small = true;
                };
              }
              {
                app = "${pkgs._1password-gui.outPath}/Applications/1Password.app";
              }
              {
                app = "/Applications/Homebrew Apps/SafeInCloud Password Manager.app";
              }
              {
                spacer = {
                  small = true;
                };
              }
              {
                app = "/Applications/Homebrew Apps/Zen.app";
              }
              {
                app = "/Applications/Safari.app";
              }
              {
                spacer = {
                  small = true;
                };
              }
              {
                app = "/Applications/Homebrew Apps/Yaak.app";
              }
              {
                app = "/Applications/TeamViewer.app";
              }
            ];
            persistent-others = [
              "${homeDirectory}/Github/personal"
              "${homeDirectory}/Github/work"
              "${homeDirectory}/Downloads"
            ];
          };
        };
      };

      system.primaryUser = username;
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

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

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
          ];
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
