{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./packages
    ./dock.nix
  ];

  options = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the primary user on this system.";
    };
    home = lib.mkOption {
      type = lib.types.str;
      description = "The home directory of the primary user on this system.";
    };
    font = lib.mkOption {
      type = lib.types.str;
      description = "The font family to use for terminal and editor applications.";
    };
    folders = lib.mkOption {
      type = lib.types.attrs;
      description = "The folders in the dock to be used for the persistent-others section.";
    };
  };

  config = {
    nixpkgs = {
      # Allow unfree software
      config.allowUnfree = true;
      # The platform the configuration will be used on.
      hostPlatform = "aarch64-darwin";
    };

    environment.customIcons = {
      enable = true;
      icons = [
        {
          path = config.folders.nix;
          icon = ./icons/nix.png;
        }
        {
          path = config.folders.personal;
          icon = ./icons/github.png;
        }
        {
          path = config.folders.work;
          icon = ./icons/github.png;
        }
        {
          path = config.folders.downloads;
          icon = ./icons/downloads.png;
        }
      ];
    };

    system = {
      # Set Git commit hash for darwin-version
      configurationRevision = config.rev or config.dirtyRev or null;
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      stateVersion = 6;
      primaryUser = config.username;
      defaults = {
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
          NewWindowTargetPath = "file://${config.home}/Github";
          ShowPathbar = true;
          ShowStatusBar = true;
        };
      };
    };

    users = {
      knownUsers = [ config.username ];
      users.${config.username} = {
        name = config.username;
        uid = 501;
        home = config.home;
        shell = pkgs.fish;
      };
    };

    nix = {
      # Automatic garbage collection
      gc.automatic = true;
      # Necessary for using flakes on this system.
      settings.experimental-features = "nix-command flakes";
    };

    # Enable alternative shell support in nix-darwin.
    programs.fish.enable = true;

    # Add ability to used TouchID for sudo authentication
    security.pam.services.sudo_local.touchIdAuth = true;
  };

}
