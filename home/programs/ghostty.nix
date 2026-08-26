{ config, ... }:
{
  config.programs.ghostty = {
    enable = true;
    package = null;
    enableFishIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-family = config.font;
    };
  };
}
