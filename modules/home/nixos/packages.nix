{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  affinity = inputs.affinity-nix.packages.x86_64-linux.v3;
in
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #gnome
    nautilus
    loupe
    showtime
    decibels
    baobab

    osu-lazer-bin
    gparted
    nicotine-plus
    affinity
    vinegar
    protonplus
    (pkgs.buildFHSEnv {
      name = "rider-env";
      targetPkgs =
        pkgs:
        (with pkgs; [
          jetbrains.rider
          dotnetCorePackages.dotnet_10.sdk
        ]);
      runScript = "nohup rider &";
    })

    # desktop
    sunsetr
    grim
    slurp
    wl-clipboard
    playerctl
    keyd
    vial

    # fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
