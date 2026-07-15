{
  imports = [
    ./launchd
    ./programs
    ./services
  ];

  config = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
