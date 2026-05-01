{ inputs, ... }:
{
  flake-file.inputs.affinity-nix.url = "github:mrshmllow/affinity-nix";

  den.aspects.applications = {
    nixos.nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave
          telegram-desktop
          qbittorrent
        ];

        programs.zathura.enable = true;
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.affinity-v3 ];
      };
  };
}
