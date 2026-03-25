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
                  inherit name;
                  runtimeInputs = runtimeInputs ++ [
                    "/opt/homebrew"
                  ];
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
        jobs =
          let
            githubUrl = "https://github.com";
            iconWithTimeout =
              name:
              "--app-icon \"https://cdn.jsdelivr.net/gh/selfhst/icons@main/webp/${name}-light.webp\" --timeout 30";
          in
          {
            dependabot-notifications = {
              runtimeInputs = [
                pkgs.gh
              ];
              text = ''
                owners=$(gh org list | paste -sd, -)
                open_pr_repos=$(
                  gh search prs \
                    --app dependabot \
                    --state open \
                    --owner "$owners" \
                    --json repository \
                    -q '[.[].repository.nameWithOwner] | unique | .[]'
                )

                if [ -z "$open_pr_repos" ]; then
                  exit 0
                fi

                action="Open Repos"
                response=$(
                  alerter \
                    --title "GitHub" \
                    --message "Open dependabot prs" \
                    --actions "$action"  \
                    ${iconWithTimeout "github"}
                )

                if [ "$response" == "$action" ]; then
                  for open_pr_repo in $open_pr_repos; do
                    open "${githubUrl}/$open_pr_repo/pulls"
                  done
                fi
              '';
            };
            flake-lock-updated = {
              runtimeInputs = [
                pkgs.git
              ];
              text = ''
                cd ${osConfig.folders.nix}
                git fetch origin

                remote_main=origin/main
                latest_remote_commit_author=$(git log -1 --format='%an' "$remote_main")

                if [[ "$latest_remote_commit_author" != "renovate[bot]" ]]; then
                  exit 0
                fi

                action="Open Commit"
                response=$(
                  alerter \
                    --title "Flake Lock Updated" \
                    --message "Renovate has updated the flake lock" \
                    --actions "$action" \
                    ${iconWithTimeout "github"}
                )

                if [ "$response" == "$action"  ]; then
                  open "${githubUrl}/commit/$(git rev-parse "$remote_main")"
                fi
              '';
            };
            prune-repos-merged-branches = {
              runtimeInputs = [
                pkgs.git
                pkgs.gh
                pkgs.gh-poi
              ];
              text = ''
                find ${osConfig.folders.github} -type d -name ".git" | while read -r dir; do
                  repo_dir=$(dirname "$dir")
                  cd "$repo_dir" && git checkout main && gh-poi
                done

                alerter \
                  --title "Prune merged branches" \
                  --message "Finished pruning merged branches in all repos" \
                  ${iconWithTimeout "git"}
              '';
            };
          };
      };
    };
}
