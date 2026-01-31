{ pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
    qbittorrent
    brave

    ripgrep
    fd
    sd
    tree
    gnumake
    blink-roblox

    cachix
    nix-info
    nixpkgs-fmt
    devenv

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
  ];
}
