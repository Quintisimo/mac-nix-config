{ lib, osConfig, ... }:
{
  imports = [
    ./launchd
    ./programs
    ./services
  ];

  options = {
    zedCli = lib.mkOption {
      type = lib.types.str;
      default = "zeditor --zed \"${osConfig.folders.hmApps}/Zed.app\"";
      description = "The path to the Zed CLI binary.";
    };
  };

  config = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
