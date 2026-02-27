{ pkgs, config, ... }:
{
  config =
    let
      createBrewCaskApp = app: {
        app = "/Applications/${app}.app";
      };
      createNixApp = pkg: app: {
        app = "${pkgs.${pkg}}/Applications/${app}.app";
      };
      createSystemApp = app: {
        app = "/System/Applications/${app}.app";
      };
      createFolder = folder: {
        folder = "${config.home}/${folder}";
      };
      createSpacer = small: {
        spacer = {
          small = small;
        };
      };
    in
    {
      system.defaults.dock = {
        wvous-bl-corner = 13;
        wvous-br-corner = 2;
        show-recents = false;
        persistent-apps = [
          (createBrewCaskApp "Zed")
          (createNixApp "ghostty-bin" "Ghostty")
          (createBrewCaskApp "OrbStack")
          (createSpacer true)
          (createSystemApp "Mail")
          (createBrewCaskApp "Discord")
          (createBrewCaskApp "Slack")
          (createBrewCaskApp "Microsoft Teams")
          (createSystemApp "Messages")
          (createSpacer true)
          (createSystemApp "Calendar")
          (createSpacer true)
          (createBrewCaskApp "1Password")
          (createBrewCaskApp "SafeInCloud Password Manager")
          (createSpacer true)
          (createBrewCaskApp "Zen")
          (createSpacer true)
          (createBrewCaskApp "Yaak")
        ];
        persistent-others = [
          (createFolder "Github/personal")
          (createFolder "Github/work")
          (createFolder "Downloads")
        ];
      };
    };
}
