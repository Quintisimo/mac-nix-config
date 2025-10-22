{ pkgs }:

with pkgs; [
  # shell plugins
  fishPlugins.hydro
  fishPlugins.z
  fishPlugins.bang-bang

  # Needed for zed bicep extension and azure-functions-core-tools
  dotnetCorePackages.aspnetcore_8_0-bin

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
  cloudflared
  claude-code
]
