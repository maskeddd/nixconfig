{
  programs.vicinae = {
    enable = true;
    useLayerShell = true;
    systemd = {
      enable = true;
      autoStart = true;
      target = "hyprland-session.target";
    };
  };
}
