{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    packages = [
      "org.vinegarhq.Sober"
      rec {
        appId = "com.hypixel.HytaleLauncher";
        sha256 = "1v153k3vns64axybkd08r63jrcj8csqks5777bncyw1rpn6rflpn";
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
