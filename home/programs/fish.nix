{
  pkgs,
  osConfig,
  ...
}:
{
  config.programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
      set -x fish_greeting
      set -x EDITOR vim
      set -x NODE_NO_WARNINGS 1

      ${if osConfig.isWork then "source ${osConfig.age.secrets.fish_env.path}" else ""}

      fish_vi_key_bindings
      fish_add_path $HOME/go/bin
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
      secret = "openssl rand -hex 32";
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
