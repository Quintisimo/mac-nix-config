{ osConfig, macos-gitignore, ... }:
{
  config = {
    xdg.configFile."git/ignore".source = "${macos-gitignore}/Global/macOS.gitignore";
    programs.git = {
      enable = true;
      includes = [
        {
          condition = "gitdir:${osConfig.folders.work}/";
          contents = {
            user = {
              email = "qcardozo@getlegaltech.com";
            };
          };
        }
      ];
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
          side-by-side = true;
        };
        fetch = {
          prune = true;
        };
        status = {
          short = true;
        };
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        merge = {
          conflictStyle = "zdiff3";
        };
        rerere = {
          enable = true;
          autoupdate = true;
        };
        help = {
          autocorrect = "prompt";
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
  };
}
