{ config, ... }:
let
  folders = config.folders;
  createApp = path: name: {
    app = "${path}${name}.app";
  };
  createFolder = folder: {
    folder = {
      path = folder;
      displayas = "folder";
    };
  };
  createSpacer =
    {
      small ? true,
    }:
    {
      spacer = {
        small = small;
      };
    };
in
{
  config =
    let
      createBrewCaskApp = createApp "/Applications/";
      createWebApp = createApp "${config.folders.webApps}/";
      createSystemApp = createApp "/System/Applications/";
    in
    {
      system.defaults.dock =
        let
          workApps = [
            (createSystemApp "Mail")
            (createBrewCaskApp "Discord")
            (createBrewCaskApp "Linear")
            (createBrewCaskApp "Slack")
            (createBrewCaskApp "Microsoft Teams")
            (createSpacer { })
            (createBrewCaskApp "1Password")
            (createSpacer { })
            (createBrewCaskApp "Yaak")
            (createBrewCaskApp "TablePro")
          ];
          personalApps = [
            (createBrewCaskApp "Helium")
            (createWebApp "YouTube Music")
            (createSpacer { })
            (createBrewCaskApp "Safe")
            (createSpacer { })
            (createSystemApp "Photos")
            (createBrewCaskApp "Affinity")
            (createBrewCaskApp "ImageOptim")
          ];
        in
        {
          wvous-bl-corner = 13; # Lock Screen
          wvous-br-corner = 2; # Mission Control
          show-recents = false;
          persistent-apps = [
            (createBrewCaskApp "Zed")
            (createBrewCaskApp "Ghostty")
            (createBrewCaskApp "OrbStack")
            (createSpacer { })
          ]
          ++ (if config.isWork then workApps else personalApps);
          persistent-others = [
            (createFolder folders.nix)
            (createFolder folders.github)
            (createFolder folders.downloads)
          ];
        };
    };
}
