{
  pkgs,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings.splash = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      # --- Variables ---
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "vicinae toggle";
      "$files" = "nautilus";
      "$lock" = "hyprlock";

      # --- Environment ---
      env = [
        "NIXOS_OZONE_WL,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "GBM_BACKEND,nvidia-drm"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,1"
      ];

      # --- Monitors ---
      monitor = [
        "DP-2, 2560x1440@120, 0x0, 1, transform, 1"
        "DP-3, 2560x1440@300, 1440x560, 1"
        "eDP-1, 3024x1964@60, 0x0, 2"
      ];

      # --- Input ---
      input = {
        accel_profile = "flat";
        sensitivity = -0.3;
      };

      # --- Layout ---
      general = {
        gaps_in = 5;
        gaps_out = "20, 20, 20, 20";
        border_size = 4;
        layout = "dwindle";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # --- Misc ---
      cursor = {
        no_hardware_cursors = 1;
      };

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        vrr = 2;
      };

      # --- Decoration ---
      decoration = {
        rounding = 0;
        rounding_power = 2;
        shadow.enabled = false;
        blur.enabled = false;
      };

      # --- Animations ---
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1"
          "quick, 0.15, 0, 0.1, 1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "zoomFactor, 1, 7, quick"
        ];
      };

      # --- Keybinds ---
      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, R, exec, $menu"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        "$mod, E, exec, $files"
        "$mod, L, exec, $lock"

        '', Print, exec, grim -g "$(slurp -d)" - | wl-copy''

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod SHIFT, LEFT, movecurrentworkspacetomonitor, +1"
        "$mod SHIFT, RIGHT, movecurrentworkspacetomonitor, -1"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      ));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # --- Window / Layer Rules ---
      windowrule = [
        "match:class .*, suppress_event maximize"
        "match:class = ^$, match:title = ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus true"

        "workspace 1, match:class ^(brave-browser)$"
        "workspace 3, match:class ^(discord)$"
        "workspace 3, match:class ^(spotify)$"
        "workspace 4, match:class ^(steam)$"

        "workspace 2, match:class ^(csgo_linux64)$"
        "fullscreen on, match:class ^(csgo_linux64)$"
      ];

      layerrule = [ "no_anim on, match:namespace vicinae" ];

      workspace = [
        "1, monitor:DP-3"
        "2, monitor:DP-3"
        "3, monitor:DP-2"
        "4, monitor:DP-2"
      ];

      # --- Autostart ---
      exec-once = [
        "${pkgs.sunsetr}/bin/sunsetr"
        "ags run"

        "[workspace 1 silent] ${pkgs.brave}/bin/brave"
        "[workspace 3 silent] discord"
        "[workspace 3 silent] spotify"

        "steam -silent"
        "${pkgs._1password-gui}/bin/1password --silent"
      ];
    };
  };
}
