{ lib, ... }: {
  imports = [
    ./claude-code.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./vim.nix
    ./zed-editor.nix
  ];

  options = {
    font = lib.mkOption {
      type = lib.types.str;
      description = "The font family to use for terminal and editor applications.";
      default = "Maple Mono NF CN";
    };
  };
}
