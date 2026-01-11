{

  windowrule = [
    "match:class .*, suppress_event maximize"
    "match:class = ^$, match:title = ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus true"

    "workspace 1, match:class ^(brave-browser)$"
    "workspace 3, match:class ^(discord)$"
    "workspace 4, match:class ^(spotify)$"
    "workspace 5, match:class ^(steam)$"
  ];

  layerrule = [ "no_anim on, match:namespace vicinae" ];

  workspace = [
    "1, monitor:DP-2"
    "2, monitor:DP-2"
    "3, monitor:DP-3"
    "4, monitor:DP-3"
  ];
}
