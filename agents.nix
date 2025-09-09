{ pkgs, homeDirectory }:

let
  waitForNetwork = ''
    while ! ping -c1 -W1 1.1.1.1 &> /dev/null ; do
      sleep 1
    done
  '';
  runOnTuesday = ''
    tuesday=2
    day=$(date +%u)

    if [ "$day" -ne "$tuesday" ]; then
      exit 0
    fi
  '';
  createAgent = { pkgs, jobs }:
    builtins.mapAttrs (name: { text, runtimeInputs ? [] }: {
      enable = true;
      config = {
        RunAtLoad = true;
        StandardErrorPath = "${homeDirectory}/Library/Logs/${name}.error.log";
        StandardOutPath = "${homeDirectory}/Library/Logs/${name}.out.log";
        Program = "${pkgs.writeShellApplication {
          inherit name text runtimeInputs;
        }}/bin/${name}";
      };
    }) jobs;
in 
  createAgent {
    inherit pkgs;
    jobs = {
      dependabot-notifications = {
        runtimeInputs = [
          pkgs.gh
          pkgs.terminal-notifier
        ];
        text = ''
          ${runOnTuesday}
          ${waitForNetwork}

          orgs=$(gh org list)
          open_pr_repos=""

          pr_author=app/dependabot
          pr_state=open

          for org in $orgs; do
            repos=$(gh repo list "$org" --json nameWithOwner -q '.[].nameWithOwner')

            for repo in $repos; do
              repo_pr_count=$(gh pr list --author "$pr_author" --state "$pr_state" --repo "$repo" --json url -q '.[].url' | wc -l)

              if [ "$repo_pr_count" -gt 0 ]; then
                open_pr_repos+="$repo"$'\n'
              fi
            done
          done

          for open_pr_repo in $open_pr_repos; do
            # latest_pr=$(gh pr list --limit 1 --author "$pr_author" --state "$pr_state" --repo "$open_pr_repo" --search "sort:updated-desc" --json number -q '.[].number')
            
            # if [ -n "$latest_pr" ]; then
              # gh pr comment "$latest_pr" --body "@dependabot recreate" --repo "$open_pr_repo"
            # fi

            url="https://github.com/$open_pr_repo/pulls"
            terminal-notifier -title "Open dependabot prs" -message "$open_pr_repo" -open "$url"
          done
        '';
      };
      prune-git-repos = {
        runtimeInputs = [
          pkgs.gh-poi
        ];
        text = ''
          ${runOnTuesday}
          ${waitForNetwork}

          find ~/Github -type d -name ".git" | while read -r dir; do
            repo_dir=$(dirname "$dir")
            cd "$repo_dir" && gh-poi
          done
        '';
      };
      mail = {
        text = "open -j /System/Applications/Mail.app";
      };
    };
  }
