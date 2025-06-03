{ pkgs, homeDirectory  }:

{
  show-recents = false;
  persistent-apps = [
    {
      app = "${pkgs.vscode.outPath}/Applications/Visual Studio Code.app";
    }
    {
      app = "/Applications/Homebrew Apps/Ghostty.app";
    }
    {
      app = "/Applications/Homebrew Apps/OrbStack.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "${pkgs.discord.outPath}/Applications/Discord.app";
    }
    {
      app = "${pkgs.slack.outPath}/Applications/Slack.app";
    }
    {
      app = "${pkgs.teams.outPath}/Applications/Teams.app";
    }
    {
      app = "/Applications/Homebrew Apps/Wrike for Mac.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/Applications/Homebrew Apps/1Password.app";
    }
    {
      app = "/Applications/Homebrew Apps/SafeInCloud Password Manager.app";
    }
    {
      spacer = {
        small = true;
      };
    }
    {
      app = "/Applications/Homebrew Apps/Zen.app";
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
      app = "/Applications/Homebrew Apps/Yaak.app";
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
