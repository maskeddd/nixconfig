{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Desktop utilities
    sunsetr
    grim
    slurp
    wl-clipboard
    playerctl
    brightnessctl
    easyeffects

    protonplus
    osu-lazer-bin
    affinity-v3
    vinegar
    heroic

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
  ];
}
