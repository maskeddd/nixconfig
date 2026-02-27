{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    packages = [
      "tv.plex.PlexDesktop"
      "org.vinegarhq.Sober"
      rec {
        appId = "com.hypixel.HytaleLauncher";
        sha256 = "OyKzn9RJWlEiY2e2VVMQ96dYWDN1r6kEez81EWSjT1Y=";
        bundle = "${pkgs.fetchurl {
          url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
          inherit sha256;
        }}";
      }
    ];
    update.onActivation = true;
    uninstallUnmanaged = true;
    uninstallUnused = true;
  };
}
