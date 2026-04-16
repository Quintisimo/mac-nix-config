{ pkgs, osConfig, ... }:
{
  config.programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
      set -g fish_greeting
      set -gx EDITOR vim
      fish_vi_key_bindings
      fish_add_path $HOME/go/bin
      source ${osConfig.age.secrets.fish_env.path}
    '';
    functions = {
      # Based on https://github.com/avimehenwal/git-refresh
      git-auto-fetch = {
        onEvent = "fish_prompt";
        body = ''
          set --local hasGit (find ./ -maxdepth 1 -type d -name .git -print)
          if test "$hasGit" = "./.git"
              git fetch --all --quiet
          end
        '';
      };
    };
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
    ];
  };
}
