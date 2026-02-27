{ config, ... }:
{
  config =
    let
      createApp = app: {
        app = "/Applications/${app}.app";
      };
      createSpacer = small: {
        spacer = {
          small = small;
        };
      };
      createSystemApp = app: {
        app = "/System/Applications/${app}.app";
      };
      createFolder = folder: {
        folder = "${config.home}/${folder}";
      };
    in
    {
      system.defaults.dock = {
        wvous-bl-corner = 13;
        wvous-br-corner = 2;
        show-recents = false;
        persistent-apps = [
          (createApp "Zed")
          (createApp "Ghostty")
          (createApp "OrbStack")
          (createSpacer true)
          (createSystemApp "Mail")
          (createApp "Discord")
          (createApp "Slack")
          (createApp "Microsoft Teams")
          (createSystemApp "Messages")
          (createSpacer true)
          (createSystemApp "Calendar")
          (createSpacer true)
          (createApp "1Password")
          (createApp "SafeInCloud Password Manager")
          (createSpacer true)
          (createApp "Zen")
          (createSpacer true)
          (createApp "Yaak")
        ];
        persistent-others = [
          (createFolder "Github/personal")
          (createFolder "Github/work")
          (createFolder "Downloads")
        ];
      };
    };
}
