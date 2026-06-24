{ ponytail, ... }:
{
  programs.claude-code = {
    enable = true;
    marketplaces = {
      ponytail = ponytail;
    };
    settings = {
      enabledPlugins = {
        "ponytail@ponytail" = true;
      };
    };
  };
}
