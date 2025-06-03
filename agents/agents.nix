{ pkgs }:

import ./create-agents.nix {
  inherit pkgs;
  jobs = {
    dependabot-notifications = {
      runtimeInputs = [
        pkgs.gh
        pkgs.terminal-notifier
      ];
      text = ''
        orgs=$(gh org list)
        open_pr_repos=""

        for org in $orgs; do
          repos=$(gh repo list "$org" --json nameWithOwner -q '.[].nameWithOwner')

          for repo in $repos; do
            repo_pr_count=$(gh pr list --author app/dependabot --state open --repo "$repo" --json url -q '.[].url' | wc -l)

            if [ "$repo_pr_count" -gt 0 ]; then
              open_pr_repos+="$repo"$'\n'
            fi
          done
        done

          for open_pr_repo in $open_pr_repos; do
          url="https://github.com/$open_pr_repo/pulls"
          terminal-notifier -title "Open dependabot prs" -message "$open_pr_repo" -open "$url"
        done
      '';
      StartCalendarInterval = [
        {
          Minute = 0;
          Hour = 9;
          Day = 2;
        }
      ];
    };
    prune-git-repos = {
      runtimeInputs = [
        pkgs.gh-poi
      ];
      text = ''
        find ~/Github -type d -name ".git" | while read -r dir; do
        repo_dir=$(dirname "$dir")
        cd "$repo_dir" && gh-poi
        done
      '';
      StartCalendarInterval = [
        {
          Minute = 0;
          Hour = 9;
          Day = 2;
        }
      ];
    };
  };
}
