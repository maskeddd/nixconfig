{ den, inputs, ... }:
{
  flake-file.inputs.aagl.url = "github:ezKEa/aagl-gtk-on-nix";

  den.aspects.gaming = {
    includes = [ den.aspects.flatpak ];

    os.nix.settings = {
      substituters = [ "https://ezkea.cachix.org" ];
      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };

    nixos =
      { pkgs, ... }:
      {
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
            extraPackages = with pkgs; [ SDL2 ];
          };
          anime-game-launcher.enable = true;
        };
      };

    homeManager =
      { pkgs, lib, ... }:
      let
        hytaleHash = "QmLLhHIam/kJETzqBr+IaishISzkxkGeDp/OCRZeyFs=";
      in
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
        programs.mangohud = {
          enable = true;
          settings = {
            full = true;
            background_alpha = lib.mkForce 0.5;
            output_folder = "~/Documents/mangohud/";
          };
        };
        services.flatpak.packages = [
          "org.vinegarhq.Sober"
          {
            appId = "com.hypixel.HytaleLauncher";
            sha256 = hytaleHash;
            bundle = "${pkgs.fetchurl {
              url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
              sha256 = hytaleHash;
            }}";
          }
        ];
      };
  };
}
