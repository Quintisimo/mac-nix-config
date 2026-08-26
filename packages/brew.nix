{ config, ... }:
{
  homebrew =
    let
      workCasks = [
        "microsoft-teams"
        "yaak"
        "discord"
        "linear"
        "tablepro"
      ];
      personalCasks = [
        "helium-browser"
        "affinity"
        "imageoptim"
        "wifiman"
      ];
      workBrews = [
        "unixodbc"
        "azure-cli"
      ];
      workExtraConfig = ''
        module Utils
          ENV['HOMEBREW_ACCEPT_EULA']='y'
        end
        brew "msodbcsql18"
        brew "mssql-tools18"
      '';
    in
    {
      enable = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };
      casks = [
        "orbstack"
        "swish"
        "maccy"
        "zed"
        "ghostty"
      ]
      ++ (if config.isWork then workCasks else personalCasks);
      masApps = {
        amphetamine = 937984704;
        numbers = 409203825;
        passwords-codes-safe = 883070818;
      };
      brews = [
        "alerter"
      ]
      ++ (if config.isWork then workBrews else [ ]);
      extraConfig = if config.isWork then workExtraConfig else "";
    };
}
