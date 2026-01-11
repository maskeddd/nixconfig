{
  input = {
    kb_layout = "us";
    kb_options = "fkeys:basic_13-24";

    follow_mouse = 1;

    sensitivity = -0.7;
  };

  "$mod" = "SUPER";
  "$terminal" = "ghostty";
  "$menu" = "vicinae toggle";
  "$files" = "nautilus";
  "$lock" = "hyprlock";

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
  ];

  bindl = [
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
  ];
}
