{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  config = {
    services.skhd =
      let
        workAppsAction =
          action:
          builtins.concatStringsSep " && " (
            map (app: "${action} \"${app}\"") [
              "Slack"
              "Discord"
              "Mail"
              "Linear"
              "zed"
              "ghostty"
            ]
          );
      in
      {
        enable = true;
        config = ''
          fn - c : ${config.zedCli} ${osConfig.folders.nix}
          fn - w : ${workAppsAction "open -a"}
          fn + shift - w : ${workAppsAction "killall"}
        '';
      };
    home.activation.reloadSkhdConfig = ''
      echo "Reloading skhd config..."
      ${pkgs.skhd}/bin/skhd -r
    '';
  };
}
