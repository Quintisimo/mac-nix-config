{ pkgs, homeDirectory  }:

{
  wvous-bl-corner = 13;
  wvous-br-corner = 2;
  show-recents = false;
  persistent-apps = [
    {
      app = "/Applications/Zed.app";
    }
    {
      app = "/Applications/Ghostty.app";
    }
    {
      app = "/Applications/OrbStack.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/System/Applications/Mail.app";
    }
    {
      app = "/Applications/Discord.app";
    }
    {
      app = "/Applications/Slack.app";
    }
    {
      app = "/Applications/Microsoft Teams.app";
    }
    {
      app = "/System/Applications/Messages.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/System/Applications/Calendar.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/Applications/1Password.app";
    }
    {
      app = "/Applications/SafeInCloud Password Manager.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/Applications/Zen.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/Applications/Yaak.app";
    }
  ];
  persistent-others = [
    "${homeDirectory}/Github/personal"
    "${homeDirectory}/Github/work"
    "${homeDirectory}/Downloads"
  ];
}
