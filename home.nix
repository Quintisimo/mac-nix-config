{ config, pkgs, ... }:

{
  home = {
    stateVersion = "25.11";
  };

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Quintus Cardozo";
      userEmail = "qcardozo@getlegaltech.com";
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
  };
}
