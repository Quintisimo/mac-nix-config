{ osConfig, ... }:
{
  config.programs.zed-editor = {
    enable = true;
    extensions = [
      "html"
      "toml"
      "catppuccin"
      "git-firefly"
      "dockerfile"
      "sql"
      "catppuccin-icons"
      "make"
      "astro"
      "nix"
      "golangci-lint"
      "caddyfile"
      "unocss"
      "pkl"
      "bicep"
      "github-actions"
    ];
    mutableUserTasks = false;
    mutableUserSettings = false;
    userSettings = {
      disable_ai = true;
      icon_theme = "Catppuccin Mocha";
      buffer_font_family = osConfig.font;
      ui_font_family = osConfig.font;
      project_panel = {
        dock = "left";
        auto_fold_dirs = false;
      };
      outline_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      autosave = "on_focus_change";
      file_types = {
        ignore = [ ".funcignore" ];
      };
      tab_size = 2;
      relative_line_numbers = "enabled";
      gutter = {
        line_numbers = true;
      };
      minimap = {
        show = "auto";
      };
      base_keymap = "VSCode";
      format_on_save = "on";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      vim_mode = true;
      ui_font_size = 14;
      buffer_font_size = 12;
      theme = {
        mode = "system";
        light = "Ayu Light";
        dark = "Catppuccin Mocha";
      };
      title_bar = {
        show_sign_in = false;
      };
      collaboration_panel = {
        button = false;
      };
      edit_predictions = {
        provider = "copilot";
      };
      languages = {
        Python = {
          format_on_save = "off";
          language_servers = [
            # Disable basedpyright and enable Ty; and otherwise
            # use the default configuration.
            "ty"
            "ruff"
            "!basedpyright"
          ];
        };
      };
    };
    userTasks = [
      {
        label = "claude";
        command = "claude --dangerously-skip-permissions";
        shell = {
          program = "sh";
        };
        hide = "on_success";
        show_summary = false;
        show_command = false;
        allow_concurrent_runs = true;
        use_new_terminal = true;
      }
    ];
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          fn-p = [
            "task::Spawn"
            {
              task_name = "claude";
              reveal_target = "center";
            }
          ];
        };
      }
    ];
  };
}
