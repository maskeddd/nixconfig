{ inputs, ... }:
{
  flake-file.inputs.affinity-nix.url = "github:mrshmllow/affinity-nix";

  den.aspects.affinity = {
    nixos = {
      nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

      nix.settings = {
        extra-substituters = [ "https://cache.forall.systems" ];
        extra-trusted-public-keys = [
          "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
        ];
      };
    };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.affinity-v3 ];
      };
  };
}
