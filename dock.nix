{ pkgs, config, ... }:
let
  folders = config.folders;
  createApp = path: name: {
    app = "${path}/Applications/${name}.app";
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
      createBrewCaskApp = createApp "";
      createNixApp = pkg: createApp "${pkgs.${pkg}}";
      createSystemApp = createApp "/System";
    in
    {
      system.defaults.dock = {
        wvous-bl-corner = 13; # Lock Screen
        wvous-br-corner = 2; # Mission Control
        show-recents = false;
        persistent-apps = [
          (createBrewCaskApp "Zed")
          (createNixApp "ghostty-bin" "Ghostty")
          (createBrewCaskApp "OrbStack")
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
          (createBrewCaskApp "Zen")
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
