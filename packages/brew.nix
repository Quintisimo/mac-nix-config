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
      "zen"
      "orbstack"
      "safeincloud-password-manager"
      "yaak"
      "1password"
      "wifiman"
      "swish"
      "discord"
      "slack"
      "maccy"
      "pearcleaner"
      "linear-linear"
      "flux-markdown"
      "dockdoor"
    ];
    masApps = {
      amphetamine = 937984704;
      numbers = 409203825;
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
