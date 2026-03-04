{ macos-gitignore, ... }:
{
  config = {
    xdg.configFile."git/ignore".source = "${macos-gitignore}/Global/macOS.gitignore";
    programs.git = {
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
  };
}
