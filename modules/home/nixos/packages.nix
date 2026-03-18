{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs;
    [
      # Desktop utilities
      sunsetr
      grim
      slurp
      wl-clipboard
      playerctl
      brightnessctl

      # GNOME apps
      nautilus
      loupe
      showtime
      decibels
      baobab

      # Development
      (pkgs.buildFHSEnv {
        name = "rider-env";
        targetPkgs =
          pkgs:
          (with pkgs; [
            jetbrains.rider
            dotnetCorePackages.dotnet_10.sdk
          ]);
        runScript = "nohup rider > /dev/null 2>&1 &";
      })

      # Fonts
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ]
    ++ lib.optionals pkgs.stdenv.isx86_64 [
      protonplus
      osu-lazer-bin
      inputs.affinity-nix.packages.x86_64-linux.v3
      vinegar
      lutris
    ];
}
