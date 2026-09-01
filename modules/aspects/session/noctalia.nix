{ inputs, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia/cachix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia = {
    os.nix.settings = {
      substituters = [ "https://noctalia.cachix.org" ];
      trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];

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
            start = [
              "session"
              "workspaces"
            ];
            widget_spacing = 14;
          };

          desktop_widgets.enabled = false;

          lockscreen.enabled = false;

          location = {
            auto_locate = true;
          };

          shell = {
            font_family = "SF Pro Text";
            button_borders = false;
            input_borders = false;
            popup_borders = false;
            card_borders = false;
            panel.borders = false;
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
  };
}
