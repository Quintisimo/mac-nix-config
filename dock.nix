{ config, ... }:
let
  folders = config.folders;
  getFullAppPath = path: name: {
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
      createApp = getFullAppPath "/Applications/";
      createWebApp = getFullAppPath "${config.folders.webApps}/";
      createSystemApp = getFullAppPath "/System/Applications/";
    in
    {
      system.defaults.dock =
        let
          workApps = [
            (createSystemApp "Mail")
            (createApp "Discord")
            (createApp "Linear")
            (createApp "Slack")
            (createApp "Microsoft Teams")
            (createSpacer { })
            (createApp "Microsoft Edge")
            (createSpacer { })
            (createApp "1Password")
            (createSpacer { })
            (createApp "Yaak")
            (createApp "TablePro")
          ];
          personalApps = [
            (createApp "Helium")
            (createWebApp "YouTube Music")
            (createSpacer { })
            (createApp "Safe")
            (createSpacer { })
            (createSystemApp "Photos")
            (createApp "Affinity")
            (createApp "ImageOptim")
          ];
        in
        {
          wvous-bl-corner = 13; # Lock Screen
          wvous-br-corner = 2; # Mission Control
          show-recents = false;
          persistent-apps = [
            (createApp "Zed")
            (createApp "Ghostty")
            (createApp "OrbStack")
            (createSpacer { })
          ]
          ++ (if config.isWork then workApps else personalApps);
          persistent-others = [
            (createFolder folders.github)
            (createFolder folders.downloads)
          ];
        };
    };
}
