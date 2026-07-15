{
  pkgs,
  osConfig,
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
        appsAction =
          action: apps: builtins.concatStringsSep " && " (map (app: "${action} \"${app}\"") apps);
      in
      {
        enable = true;
        config = ''
          fn - c : zed ${osConfig.folders.nix}
          fn - w : ${appsAction "open -a" openApps}
          fn + shift - w : ${appsAction "killall" (openApps ++ killApps)}
        '';
      };
    home.activation.reloadSkhdConfig = ''
      echo "Reloading skhd config..."
      ${pkgs.skhd}/bin/skhd -r
    '';
  };
}
