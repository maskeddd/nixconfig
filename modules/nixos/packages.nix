{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
  ];

  environment.systemPackages = with pkgs; [
    patchelfUnstable
    xwayland-satellite

    gnomeExtensions.appindicator
    gnomeExtensions.vicinae
  ];
}
