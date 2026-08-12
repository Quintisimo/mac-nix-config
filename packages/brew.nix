{ config, ... }:
{
  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "microsoft-teams"
      "orbstack"
      "yaak"
      "1password"
      "wifiman"
      "swish"
      "discord"
      "slack"
      "maccy"
      "linear"
      "helium-browser"
      "affinity"
      "tablepro"
      "zed"
      "ghostty"
      "imageoptim"
    ];
    masApps = {
      amphetamine = 937984704;
      numbers = 409203825;
      passwords-codes-safe = 883070818;
    };
    brews = [
      "unixodbc"
      "azure-cli"
      "alerter"
    ];
    extraConfig = ''
      module Utils
        ENV['HOMEBREW_ACCEPT_EULA']='y'
      end
      brew "msodbcsql18"
      brew "mssql-tools18"
    '';
  };
}
