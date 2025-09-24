{ pkgs, config, homeDirectory, ... }:

let
  fontFamily = "FiraCode Nerd Font Mono";
in
  {
    age = {
      identityPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
      secrets = {
        fish_env = {
          file = ./secrets/secrets.age;
        };
      };
    };

    home = {
      stateVersion = "25.11";
      file = {
        # Use home.file as program.ghostty is currently broken
        ghostty = {
          target = ".config/ghostty/config";
          text = ''
            theme = catppuccin-mocha
            font-family = ${fontFamily}
          '';
        };
      };
    };

    targets = {
      darwin = {
        defaults = {
          "com.microsoft.VSCode" = {
            ApplePressAndHoldEnabled = false;
          };
        };
      };
    };

    programs = {
      home-manager = {
        enable = true;
      };
      git = {
        enable = true;
        aliases = {
          update = "rebase origin/main";
          force-push = "push --force-with-lease";
          fixup = "!sh -c 'git add . && git commit --fixup=$1 && git rebase --autosquash $1~1'";
          amend = "!sh -c 'git add . && git commit --amend --no-edit'";
        };
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
          init = {
            defaultBranch = "main";
          };
        };
      };
      fish = {
        enable = true;
        generateCompletions = true;
        interactiveShellInit = ''
          set -g fish_greeting
          set -gx EDITOR vim
          fish_vi_key_bindings
          source ${config.age.secrets.fish_env.path}
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
          {
            name = "z";
            src = pkgs.fishPlugins.z.src;
          }
          {
            name = "bang-bang";
            src = pkgs.fishPlugins.bang-bang.src;
          }
        ];
      };
      poetry = {
        enable = true;
        settings = {
          virtualenvs.in-project = true;
        };
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
            userSettings = import ./vscode/settings.nix {
              inherit fontFamily;
              dotnetPath = "${pkgs.dotnetCorePackages.runtime_8_0-bin.src}/bin/dotnet";
            };
          };
        };
      };
    };
    
    # Cron Agents
    launchd = {
      enable = true;
      agents = import ./agents.nix {
        inherit pkgs;
        inherit homeDirectory;
      };
    };
  }
