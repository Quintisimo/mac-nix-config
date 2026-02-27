{
  imports = [
    ./agents.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./vim.nix
    ./zed-editor.nix
  ];

  config = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
