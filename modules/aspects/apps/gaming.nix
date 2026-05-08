{ den, inputs, ... }:
{
  flake-file.inputs.aagl.url = "github:ezKEa/aagl-gtk-on-nix";

  den.aspects.gaming = {
    includes = [ den.aspects.flatpak ];

    nixos = {
      imports = [ inputs.aagl.nixosModules.default ];

      nixpkgs.overlays = [
        (final: prev: {
          openldap = prev.openldap.overrideAttrs (_: {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          });
        })
      ];

      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
        anime-game-launcher.enable = true;
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          protonplus
          osu-lazer-bin
          vinegar
          lutris

          (prismlauncher.override {
            jdks = with pkgs; [
              zulu25
              zulu21
              zulu17
            ];
          })

          patchelfUnstable
        ];
        services.flatpak.packages = [
          "org.vinegarhq.Sober"
          {
            appId = "com.hypixel.HytaleLauncher";
            sha256 = "QmLLhHIam/kJETzqBr+IaishISzkxkGeDp/OCRZeyFs=";
            bundle = "${pkgs.fetchurl {
              url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
              sha256 = "QmLLhHIam/kJETzqBr+IaishISzkxkGeDp/OCRZeyFs=";
            }}";
          }
        ];
      };
  };
}
