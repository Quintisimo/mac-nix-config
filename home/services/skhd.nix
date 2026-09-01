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
          fn - c : open -a "Zed" "${osConfig.folders.nix}"
          ${if osConfig.isWork then workShortcuts else ""}
        '';
      };
    home.activation.reloadSkhdConfig = lib.hm.dag.entryAfter [ "setupLaunchAgents" ] ''
      echo "Reloading skhd config..."
      ${pkgs.skhd}/bin/skhd -r || true
    '';
  };
}
