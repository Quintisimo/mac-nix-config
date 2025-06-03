{ pkgs, ... }:

{
  home = {
    stateVersion = "25.11";
    file = {
      # Use home.file as program.ghostty is currently broken
      ghostty = {
        target = ".config/ghostty/config";
        text = ''
          theme = catppuccin-mocha
          font-family = SpaceMono Nerd Font Mono
        '';
      };
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      includes = [
        {
          condition  = "gitdir:~/Github/work/";
          contents = {
            user = {
              email = "qcardozo@getlegaltech.com";
            };
          };
        }
      ];
      userName = "Quintus Cardozo";
      userEmail = "quintuscardozo13@gmail.com";
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
	      set -g fish_greeting
	      fish_vi_key_bindings
      '';
      shellAliases = {
	      ls = "eza -la";
        cat = "bat";
      };
      plugins = [
        {
          name = "hydro";
          src = pkgs.fishPlugins.hydro.src;
        }
      ];
    };
    vim = {
      enable = true;
      settings = {
	      background = "dark";
	      tabstop = 2;
	      relativenumber = true;
      };
    };
    vscode = {
      enable = true;
      profiles = {
        default = {
          extensions = import ./vscode/extensions.nix { 
            inherit pkgs;
          };
          userSettings = import ./vscode/settings.nix;
        };
      };
    };
  };
  
  # Cron Agents
  launchd = {
    enable = true;
    agents = import ./agents/agents.nix {
      inherit pkgs;
    };
  };
}
