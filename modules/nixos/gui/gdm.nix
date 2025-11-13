{
  services.displayManager.gdm.enable = true;

  systemd.tmpfiles.rules = [
    "r /run/gdm/.config/monitors.xml - - - - -"
    "C /run/gdm/.config/monitors.xml - - - - ${./monitors.xml}"
    "Z /run/gdm/.config - gdm gdm - -"
  ];
}
