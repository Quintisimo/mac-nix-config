{ pkgs }:

with pkgs; [
  # shell plugins
  fishPlugins.hydro

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

  # applications
  discord
  the-unarchiver
  teams
  slack
  maccy
]
