{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    raycast
    ice-bar
    kanata
    karabiner-dk

    jetbrains.rider
    dotnetCorePackages.sdk_10_0-bin
  ];
}
