{
  config,
  flake,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    XCURSOR_SIZE = 24;
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = flake.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      flake.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "uwsm app -- ghostty";
      "$menu" = "vicinae toggle";
      "$files" = "uwsm app -- nautilus";
      "$lock" = "uwsm app -- hyprlock";

      exec-once = [
        "uwsm app -- sunsetr"
        "uwsm app -- ags run"
        "[workspace 1 silent] uwsm app -- brave"
        "[workspace 3 silent] uwsm app -- discord"
        "[workspace 4 silent] uwsm app -- spotify"
        "[workspace 5 silent] uwsm app -- steam"
      ];

      cursor = {
        no_hardware_cursors = 1;
      };

      input = {
        kb_layout = "us";
        kb_options = "fkeys:basic_13-24";

        follow_mouse = 1;

        sensitivity = -0.7;
      };

      general = {
        gaps_in = 5;
        gaps_out = "10, 20, 20, 20";

        border_size = 4;

        # "col.active_border" = "rgb(b4befe)";
        # "col.inactive_border" = "rgb(313244)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        rounding_power = 2;

        shadow.enabled = false;
        blur.enabled = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
        focus_on_activate = true;
        vrr = 2;
      };

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

      monitor = [
        "DP-2, 2560x1440@240, 2560x0, 1"
        "DP-3, 2560x1440@120.00, 0x0, 1"
      ];

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, R, exec, $menu"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        "$mod, E, exec, $files"
        "$mod, L, exec, $lock"

        '', Print, exec, grim -g "$(slurp -d)" - | wl-copy''

        ", mouse:275, pass, class:^(discord)$"

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
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "workspace 1, class:^(brave-browser)$"
        "workspace 2, class:^(dev.zed.Zed)$"
        "workspace 2, title:^(Sober)$"
        "workspace 3, class:^(discord)$"
        "workspace 4, class:^(spotify)$"
      ];

      layerrule = [ "noanim, vicinae" ];

      workspace = [
        "1, monitor:DP-2"
        "2, monitor:DP-2"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
      ];
    };
  };
}
