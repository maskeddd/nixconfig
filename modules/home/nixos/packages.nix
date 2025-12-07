{ flake, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #gnome
    nautilus
    loupe
    showtime
    decibels
    baobab

    brave
    osu-lazer-bin
    plex-desktop
    gpu-screen-recorder-gtk
    gparted
    nicotine-plus
    plexamp
    flake.inputs.affinity-nix.packages.x86_64-linux.v3

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
