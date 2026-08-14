{
  pkgs,
  osConfig,
  lib,
  ...
}:
{
  config = {
    services.skhd =
      let
        openApps = [
          "Slack"
          "Mail"
          "Linear"
        ];
        killApps = [
          "Discord"
          "zed"
          "ghostty"
        ];
      in
      {
        enable = true;
        config = ''
          fn - c : zed ${osConfig.folders.nix}
          fn - w : ${lib.join " && " (map (app: "open -a \"${app}\"") openApps)}
          fn + shift - w : killall ${lib.join " " (openApps ++ killApps)}
        '';
      };
    home.activation.reloadSkhdConfig = ''
      echo "Reloading skhd config..."
      ${pkgs.skhd}/bin/skhd -r
    '';
  };
}
