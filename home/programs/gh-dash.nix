{ osConfig, ... }:
{
  config.programs.gh-dash = {
    enable = true;
    settings = {
      theme = {
        colors = {
          text = {
            primary = "#cdd6f4";
            secondary = "#cba6f7";
            inverted = "#11111b";
            faint = "#bac2de";
            warning = "#f9e2af";
            success = "#a6e3a1";
            error = "#f38ba8";
          };
          background = {
            selected = "#313244";
          };
          border = {
            primary = "#cba6f7";
            secondary = "#45475a";
            faint = "#313244";
          };
        };
      };
      prSections =
        let
          orgs = "${
            builtins.concatStringsSep " " (map (org: "org:${org}") osConfig.githubOrgs)
          } user:${osConfig.username}";
          bot = "author:app/dependabot";
        in
        [
          {
            title = "Open Developer Pull Requests";
            filters = "is:open -${bot} ${orgs}";
          }
          {
            title = "Open Dependabot Pull Requests";
            filters = "is:open ${bot} ${orgs}";
          }
        ];
      pager = {
        diff = "delta";
      };
      defaults = {
        prApproveComment = "LGTM";
      };
      smartFilteringAtLaunch = false;
    };
  };
}
