{ pkgs, homeDirectory  }:

{
  show-recents = false;
  persistent-apps = [
    {
      app = "${pkgs.vscode.outPath}/Applications/Visual Studio Code.app";
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
      app = "${pkgs.discord.outPath}/Applications/Discord.app";
    }
    {
      app = "${pkgs.slack.outPath}/Applications/Slack.app";
    }
    {
      app = "/Applications/Microsoft Teams.app";
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
      app = "/Applications/Wrike for Mac.app";
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
      app = "/Applications/Safari.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/Applications/Yaak.app";
    }
    {
      app = "/Applications/TeamViewer.app";
    }
  ];
  persistent-others = [
    "${homeDirectory}/Github/personal"
    "${homeDirectory}/Github/work"
    "${homeDirectory}/Downloads"
  ];
}
