{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    adwaita-icon-theme
    networkmanagerapplet
  ];
}
