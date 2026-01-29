{ pkgs }:

with pkgs; [
  # shell plugins
  fishPlugins.hydro
  fishPlugins.z
  fishPlugins.bang-bang

  # Needed for zed bicep extension and azure-functions-core-tools
  dotnetCorePackages.aspnetcore_10_0-bin

  # Needed for zed pkl extension
  javaPackages.compiler.temurin-bin.jre-25

  # cli tools
  bat
  eza
  gh
  gh-poi
  terminal-notifier
  azure-functions-core-tools
  nodejs_22
  pnpm
  nodePackages.vercel
  cloudflared
  claude-code
  go
  pkl
  uv
  azurite
  delta
  yq-go
]
