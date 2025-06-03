{ pkgs }:

with pkgs; [
  # shell
  fish
  fishPlugins.hydro

  # cli tools
  bat
  eza
  gh
  gh-poi
  terminal-notifier
  azure-cli
  azure-functions-core-tools
  poetry
  nodejs_22
  pnpm

  # applications
  discord
  the-unarchiver
  teams
  slack
  vscode
  maccy
]
