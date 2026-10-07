{ den, inputs, ... }:
{
  flake-file.inputs.aagl = {
    url = "github:ezKEa/aagl-gtk-on-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.gaming = {
    includes = [ den.aspects.roblox ];

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
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          protonplus
          osu-lazer-bin
          bottles

          (prismlauncher.override {
            jdks = with pkgs; [
              temurin-bin-25
            ];
            additionalLibs = [ libxkbcommon ];
          })

          (heroic.override {
            extraPkgs =
              pkgs': with pkgs'; [
                gamemode
              ];
          })

          patchelfUnstable
        ];
      };
  };
}
