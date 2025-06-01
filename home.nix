{ config, pkgs, ... }:

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
        default= {
          extensions = with pkgs.vscode-marketplace; [
            bierner.markdown-mermaid
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            christian-kohler.path-intellisense
            dbaeumer.vscode-eslint
            docker.docker
            dotjoshjohnson.xml
            esbenp.prettier-vscode
            github.vscode-github-actions
            mhutchie.git-graph
            mikestead.dotenv
            ms-azuretools.vscode-bicep
            ms-python.debugpy
            ms-python.python
            ms-python.vscode-pylance
            redhat.vscode-xml
            redhat.vscode-yaml
            timonwong.shellcheck
            usernamehw.errorlens
            vercel.turbo-vsc
            vscodevim.vim
            yoavbls.pretty-ts-errors
          ];
          userSettings = {
            "editor.fontFamily" = "SpaceMono Nerdd Font Mono";
            "editor.fontLigatures" = true;
            "editor.cursorSmoothCaretAnimation" = "on";
            "editor.fontVariations" = true;
            "editor.formatOnSave" = true;
            "workbench.colorTheme" = "Catppuccin Mocha";
            "editor.tabSize" = 2;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "security.workspace.trust.untrustedFiles" = "open";
            "git.enableSmartCommit" = true;
            "git.autofetch" = true;
            "diffEditor.ignoreTrimWhitespace" = true;
            "git.confirmSync" = false;
            "explorer.compactFolders" = false;
            "javascript.updateImportsOnFileMove.enabled" = "always";
            "typescript.updateImportsOnFileMove.enabled" = "always";
            "git.replaceTagsWhenPull" = true;
            "turbo.useLocalTurbo" = true;
            "yaml.schemas" = {
              "https =//json.schemastore.org/github-action.json" = ".github/actions/*.{yml;yaml}";
            };
            "files.associations" = {
              ".funcignore" = "ignore";
            };
            "editor.lineNumbers" = "relative";
            "[bicep]" = {
              "editor.defaultFormatter" = "ms-azuretools.vscode-bicep";
            };
            "[bicep-params]" = {
              "editor.defaultFormatter" = "ms-azuretools.vscode-bicep";
            };
            "[xml]" = {
              "editor.defaultFormatter" = "redhat.vscode-xml";
            };
            "files.autoSave" = "onFocusChange";
            "workbench.iconTheme" = "catppuccin-mocha";
            "extensions.ignoreRecommendations" = true;
            "vim.camelCaseMotion.enable" = true;
            "vim.highlightedyank.enable" = true;
            "vim.smartRelativeLine" = true;
            "vim.statusBarColorControl" = true;
            "vim.useSystemClipboard" = true;
            "workbench.colorCustomizations" = {
              "statusBar.background" = "#5f0000";
              "statusBar.noFolderBackground" = "#5f0000";
              "statusBar.debuggingBackground" = "#5f0000";
              "statusBar.foreground" = "#ffffff";
              "statusBar.debuggingForeground" = "#ffffff";
            };
          };
        };
      };
    };
  };
}
