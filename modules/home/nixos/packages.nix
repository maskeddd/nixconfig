{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #gnome
    nautilus
    loupe
    showtime
    decibels
    baobab

    easyeffects
    solaar
    osu-lazer-bin
    davinci-resolve
    plex-desktop
    gpu-screen-recorder-gtk

    # desktop
    sunsetr
    grim
    slurp
    wl-clipboard
    playerctl
    keyd

    # fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
