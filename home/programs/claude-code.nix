{ ponytail, ... }:
{
  programs.claude-code = {
    enable = true;
    marketplaces = {
      ponytail = ponytail;
    };
    settings = {
      permissions = {
        defaultMode = "bypassPermissions";
      };
      enabledPlugins = {
        "ponytail@ponytail" = true;
      };
    };
  };
}
