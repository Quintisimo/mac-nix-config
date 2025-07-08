{ pkgs }:

with pkgs; [
  # shell plugins
  fishPlugins.hydro
  fishPlugins.z
  fishPlugins.bang-bang

  # Needed for vscode bicep extension 
  dotnetCorePackages.runtime_8_0-bin

  # cli tools
  bat
  eza
  gh
  gh-poi
  terminal-notifier
  azure-cli
  azure-functions-core-tools
  nodejs_22
  pnpm
  nodePackages.vercel

  # applications
  discord
  slack
  maccy
]
