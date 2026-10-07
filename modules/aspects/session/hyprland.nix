{ den, ... }:
{
  den.aspects.hyprland = {
    includes = with den.aspects; [
      noctalia
      hyprlock
      hypridle
      gnome-apps
    ];

    nixos = {
      programs.hyprland.enable = true;
      services = {
        displayManager.gdm.enable = true;
        gnome.gnome-keyring.enable = true;
      };
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        services.polkit-gnome.enable = true;
        xdg.mimeApps.enable = true;

        home.packages = with pkgs; [
          grim
          glib.bin
          slurp
          wl-clipboard
          playerctl
          brightnessctl
          sunsetr
        ];

        programs.satty = {
          enable = true;
          settings.general = {
            fullscreen = true;
            floating-hack = true;
            early-exit = [ "all" ];
            initial-tool = "brush";
            copy-command = "wl-copy";
            actions-on-enter = [ "save-to-clipboard" ];
            output-filename = "~/Pictures/Screenshots/screenshot-%Y%m%d-%H%M%S.png";
          };
        };

        services.hyprpaper = {
          enable = true;
          settings.splash = false;
        };

        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          systemd.variables = [ "--all" ];
          configType = "lua";
          extraLuaFiles.config = ./hyprland.lua;
        };
      };
  };
}
