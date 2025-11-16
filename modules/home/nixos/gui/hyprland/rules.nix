{
  windowrule = [
    "suppressevent maximize, class:.*"
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    "workspace 1, class:^(brave-browser)$"
    "workspace 2, class:^(dev.zed.Zed)$"
    "workspace 2, title:^(Sober)$"
    "workspace 3, class:^(discord)$"
    "workspace 4, class:^(spotify)$"
    "workspace 5, class:^(steam)$"
  ];

  layerrule = [ "noanim, vicinae" ];

  workspace = [
    "1, monitor:DP-2"
    "2, monitor:DP-2"
    "3, monitor:DP-3"
    "4, monitor:DP-3"
  ];
}
