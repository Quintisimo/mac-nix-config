{
  pkgs,
  osConfig,
  ...
}:
{
  config.launchd =
    let
      createAgent =
        { pkgs, jobs }:
        builtins.mapAttrs (
          name:
          {
            text,
            runtimeInputs ? [ ],
          }:
          {
            enable = true;
            config = {
              RunAtLoad = true;
              StandardErrorPath = "${osConfig.home}/Library/Logs/${name}/${name}.error.log";
              StandardOutPath = "${osConfig.home}/Library/Logs/${name}/${name}.out.log";
              Program = "${
                pkgs.writeShellApplication {
                  inherit name runtimeInputs;
                  text = ''
                    # Wait for network connectivity before running the job
                    while ! ping -c1 -W1 1.1.1.1 &> /dev/null ; do
                      sleep 1
                    done

                    ${text}
                  '';
                }
              }/bin/${name}";
            };
          }
        ) jobs;
    in
    {
      enable = true;
      agents = createAgent {
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
                url="https://github.com/$open_pr_repo/pulls"
                terminal-notifier -title "Open dependabot prs" -message "$open_pr_repo" -open "$url"
              done
            '';
          };
          flake-lock-updated = {
            runtimeInputs = [
              pkgs.git
              pkgs.terminal-notifier
            ];
            text = ''
              cd ${osConfig.folders.nix}
              git fetch origin

              remote_main=origin/main
              latest_remote_commit_author=$(git log -1 --format='%an' "$remote_main")

              if [ "$latest_remote_commit_author" = "renovate[bot]" ]; then
                url=$(git config --get remote.origin.url | sed 's/\.git$//')/commit/$(git rev-parse "$remote_main")
                terminal-notifier -title "Flake Lock Updated" -message "Renovate has updated the flake lock" -open "$url"
              fi
            '';
          };
          prune-repos-merged-branches = {
            runtimeInputs = [
              pkgs.git
              pkgs.gh
              pkgs.gh-poi
              pkgs.terminal-notifier
            ];
            text = ''
              find ${osConfig.folders.github} -type d -name ".git" | while read -r dir; do
                repo_dir=$(dirname "$dir")
                cd "$repo_dir" && git checkout main && gh-poi
              done
              terminal-notifier -title "Prune merged branches" -message "Finished pruning merged branches in all repos"
            '';
          };
        };
      };
    };
}
