{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs;
    [
      #gnome
      nautilus
      loupe
      showtime
      decibels
      baobab

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
      brightnessctl

      # fonts
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ]
    ++ lib.optionals pkgs.stdenv.isx86_64 [
      osu-lazer-bin
      inputs.affinity-nix.packages.x86_64-linux.v3
      vinegar
      (lutris.override {
        extraPkgs = pkgs: [
          pkgs.wineWowPackages.stagingFull
          pkgs.winetricks
        ];
      })
    ];
}
