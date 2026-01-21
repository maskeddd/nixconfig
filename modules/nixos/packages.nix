{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    networkmanagerapplet
  ];
}
