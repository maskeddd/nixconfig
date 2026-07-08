{ inputs, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia.homeManager = {
    imports = [ inputs.noctalia.homeModules.default ];

    stylix.targets.noctalia.colors.enable = false;

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        bar.default = {
          center = [ "media" ];
          end = [
            "tray"
            "notifications"
            "clipboard"
            "volume"
            "network"
            "battery"
            "control-center"
            "clock"
          ];
          margin_edge = 0;
          margin_ends = 0;
          radius = 0;
          radius_bottom_left = -80;
          radius_bottom_right = -80;
          start = [
            "session"
            "workspaces"
          ];
          widget_spacing = 14;
        };

        desktop_widgets.enabled = false;

        location = {
          auto_locate = true;
        };

        shell = {
          font_family = "SF Pro Text";
          panel.borders = false;
        };

        theme = {
          builtin = "Catppuccin";
          community_palette = "Catppuccin Lavender";
          mode = "dark";
          source = "community";

          templates = {
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };

        wallpaper.enabled = false;

        calendar.enabled = true;

        widget = {
          clock.format = "{:%a %d %b %-I:%M %p}";
          network.show_label = false;
        };
      };
    };
  };
}
