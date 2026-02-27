{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./agents.nix
  ];

  options = {
    font = lib.mkOption {
      type = lib.types.str;
      description = "The font family to use for terminal and editor applications.";
    };
  };

  config = {
    home-manager.users.${config.username} = {
      home.stateVersion = "25.11";

      programs = {
        home-manager = {
          enable = true;
        };
        git = {
          enable = true;
          includes = [
            {
              condition = "gitdir=~/Github/work/";
              contents = {
                user = {
                  email = "qcardozo@getlegaltech.com";
                };
              };
            }
          ];
          ignores = [ ".DS_Store" ];
          settings = {
            core = {
              pager = "delta";
            };
            user = {
              name = "Quintus Cardozo";
              email = "quintuscardozo13@gmail.com";
            };
            init = {
              defaultBranch = "main";
            };
            interactive = {
              diffFilter = "delta --color-only";
            };
            delta = {
              navigate = "true";
              dark = "true";
            };
            merge = {
              conflictStyle = "zdiff3";
            };
            alias = {
              undo = "reset --soft HEAD~1";
              update = "rebase origin/main";
              force-push = "push --force-with-lease";
              fixup = "!sh -c 'git add . && git commit --fixup=$1 && git rebase --autosquash $1~1'";
              amend = "!sh -c 'git add . && git commit --amend --no-edit'";
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
            fish_add_path $HOME/go/bin
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
        vim = {
          enable = true;
          settings = {
            background = "dark";
            tabstop = 2;
            relativenumber = true;
          };
        };
        ghostty = {
          enable = true;
          package = pkgs.ghostty-bin;
          enableFishIntegration = true;
          settings = {
            theme = "Catppuccin Mocha";
            font-family = config.font;
          };
        };
        zed-editor = {
          enable = true;
          extensions = [
            "html"
            "toml"
            "catppuccin"
            "git-firefly"
            "dockerfile"
            "sql"
            "catppuccin-icons"
            "make"
            "astro"
            "nix"
            "golangci-lint"
            "caddyfile"
            "unocss"
            "pkl"
            "bicep"
            "github-actions"
          ];
          userSettings = {
            agent = {
              default_model = {
                provider = "copilot_chat";
                model = "gpt-4.1";
              };
              model_parameters = [ ];
            };
            icon_theme = "Catppuccin Mocha";
            buffer_font_family = config.font;
            ui_font_family = config.font;
            project_panel = {
              auto_fold_dirs = false;
            };
            autosave = "on_focus_change";
            file_types = {
              ignore = [ ".funcignore" ];
            };
            tab_size = 2;
            relative_line_numbers = "enabled";
            gutter = {
              line_numbers = true;
            };
            minimap = {
              show = "auto";
            };
            base_keymap = "VSCode";
            format_on_save = "on";
            telemetry = {
              diagnostics = false;
              metrics = false;
            };
            vim_mode = true;
            ui_font_size = 14;
            buffer_font_size = 12;
            theme = {
              mode = "system";
              light = "Ayu Light";
              dark = "Catppuccin Mocha";
            };
            title_bar = {
              show_sign_in = false;
            };
            collaboration_panel = {
              button = false;
            };
            notification_panel = {
              button = false;
            };
            edit_predictions = {
              provider = "copilot";
            };
            languages = {
              Python = {
                format_on_save = "off";
                language_servers = [
                  # Disable basedpyright and enable Ty; and otherwise
                  # use the default configuration.
                  "ty"
                  "ruff"
                  "!basedpyright"
                ];
              };
            };
          };
        };
      };
    };
  };
}
