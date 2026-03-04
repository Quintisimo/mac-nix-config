{ pkgs, osConfig, ... }:
{
  config.programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableFishIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-family = osConfig.font;
    };
  };
}
