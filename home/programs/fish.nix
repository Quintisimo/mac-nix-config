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
}
