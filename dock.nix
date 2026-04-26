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
      createHomeManagerApp = createApp "${config.folders.hmApps}/";
      createWebApp = createApp "${config.folders.webApps}/";
      createSystemApp = createApp "/System/Applications/";
    in
    {
      system.defaults.dock = {
        wvous-bl-corner = 13; # Lock Screen
        wvous-br-corner = 2; # Mission Control
        show-recents = false;
        persistent-apps = [
          (createHomeManagerApp "Zed")
          (createHomeManagerApp "Ghostty")
          (createBrewCaskApp "OrbStack")
          (createBrewCaskApp "Linear")
          (createSpacer { })
          (createSystemApp "Mail")
          (createBrewCaskApp "Discord")
          (createBrewCaskApp "Slack")
          (createBrewCaskApp "Microsoft Teams")
          (createSystemApp "Messages")
          (createSpacer { })
          (createSystemApp "Calendar")
          (createSpacer { })
          (createBrewCaskApp "1Password")
          (createBrewCaskApp "SafeInCloud Password Manager")
          (createSpacer { })
          (createBrewCaskApp "Helium")
          (createWebApp "YouTube Music")
          (createSpacer { })
          (createBrewCaskApp "Yaak")
        ];
        persistent-others = [
          (createFolder folders.nix)
          (createFolder folders.personal)
          (createFolder folders.work)
          (createFolder folders.downloads)
        ];
      };
    };
}
