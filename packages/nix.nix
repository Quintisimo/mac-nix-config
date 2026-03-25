{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # Needed for zed bicep extension
    dotnetCorePackages.aspnetcore_10_0-bin

    # Needed for zed pkl extension
    javaPackages.compiler.temurin-bin.jre-25

    # cli tools
    bat
    eza
    gh
    gh-poi
    azure-functions-core-tools
    pnpm
    cloudflared
    claude-code
    go
    pkl
    uv
    azurite
    delta
    yq-go
    nil
    nixd
  ];

  fonts.packages = with pkgs; [
    maple-mono.NF-CN-unhinted
  ];
}
