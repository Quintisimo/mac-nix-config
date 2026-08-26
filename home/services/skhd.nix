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
        workShortcuts = ''
          fn - w : ${lib.join " && " (map (app: "open -a \"${app}\"") openApps)}
          fn + shift - w : killall ${lib.join " " (openApps ++ killApps)}
        '';
      in
      {
        enable = true;
        config = ''
          fn - c : zed ${osConfig.folders.nix}
          ${if osConfig.isWork then workShortcuts else ""}
        '';
      };
    home.activation.reloadSkhdConfig = ''
      echo "Reloading skhd config..."
      ${pkgs.skhd}/bin/skhd -r
    '';
  };
}
