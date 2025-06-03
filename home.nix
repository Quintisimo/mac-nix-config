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

  
  # Cron Jobs
  launchd = {
    enable = true;
    agents = {} // (let 
        dn = "dependabot-notifications";
        pgr = "prune-git-repos";
      in {
        ${dn} = {
          enable = true;
          config = {
            Program = "${pkgs.writeShellApplication {
              name = dn;
              runtimeInputs = [
                pkgs.gh
                pkgs.terminal-notifier
              ];
              text = ''
                orgs=$(gh org list)
                open_pr_repos=""

                for org in $orgs; do
                  repos=$(gh repo list "$org" --json nameWithOwner -q '.[].nameWithOwner')

                  for repo in $repos; do
                    repo_pr_count=$(gh pr list --author app/dependabot --state open --repo "$repo" --json url -q '.[].url' | wc -l)

                    if [ "$repo_pr_count" -gt 0 ]; then
                      open_pr_repos+="$repo"$'\n'
                    fi
                  done
                done

                for open_pr_repo in $open_pr_repos; do
                  url="https://github.com/$open_pr_repo/pulls"
                  terminal-notifier -title "Open dependabot prs" -message "$open_pr_repo" -open "$url"
                done
              '';
            }}/bin/${dn}";
            StartCalendarInterval = [
              {
                Minute = 0;
                Hour = 9;
                Day = 2;
              }
            ];
        };
      };
      ${pgr} = {
        enable = true;
        config = {
          Program = "${pkgs.writeShellApplication {
            name = pgr;
            runtimeInputs = [
              pkgs.gh-poi
            ];
            text = ''
              find ~/Github -type d -name ".git" | while read -r dir; do
                repo_dir=$(dirname "$dir")
                cd "$repo_dir" && gh-poi
              done
            '';
          }}/bin/${pgr}";
          StartCalendarInterval = [
            {
              Minute = 0;
              Hour = 9;
              Day = 2;
            }
          ];
        };
      };
    });
  };
}
