{ den, inputs, ... }:
{
  flake-file.inputs = {
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grimoire.url = "github:Slush97/grimoire/stable";
  };

  den.aspects.gaming = {
    includes = [ den.aspects.flatpak ];

    darwin.homebrew.casks = [ "roblox" ];

    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.aagl.nixosModules.default ];

        nix.settings = {
          substituters = [
            "https://ezkea.cachix.org"
            "https://grimoire.cachix.org"
          ];
          trusted-public-keys = [
            "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
            "grimoire.cachix.org-1:5Y9dQ9wk9z4BsOnkv9t8ULcsnnaJ1zSMnzOd1dV5QbA="
          ];
        };

        programs = {
          steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            extraCompatPackages = with pkgs; [
              proton-ge-bin
            ];
            extraPackages = [ pkgs.SDL2 ];
          };
          gamescope.enable = true;
          anime-game-launcher.enable = true;
        };
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          osu-lazer-bin
          inputs.grimoire.packages.${pkgs.stdenv.hostPlatform.system}.default

          (bottles.override {
            extraPkgs = _: [ wineWow64Packages.unstable ];
          })

          (prismlauncher.override {
            jdks = [
              temurin-bin-25
              temurin-bin-17
            ];
          })

          patchelfUnstable
        ];

        services.flatpak.packages = [ "org.vinegarhq.Sober" ];
      };
  };
}
