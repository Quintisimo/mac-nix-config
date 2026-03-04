{ pkgs, osConfig, ... }:
{
  config = {
    services.skhd = {
      enable = true;
      config = ''
        fn - c : zed ${osConfig.folders.nix}
      '';
    };
    home.activation.reloadSkhdConfig = ''
      echo "Reloading skhd config..."
      ${pkgs.skhd}/bin/skhd -r
    '';
  };
}
