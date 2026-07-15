{ osConfig, ... }:
{
  config.programs.zed-editor = {
    enable = true;
    package = null;
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
      agent_servers = {
        "claude-acp" = {
          type = "registry";
        };
      };
      agent = {
        dock = "right";
        sidebar_side = "right";
        default_model = {
          provider = "copilot_chat";
          model = "gpt-4.1";
        };
        model_parameters = [ ];
      };
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
  };
}
