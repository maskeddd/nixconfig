{ inputs, ... }:
{
  flake-file.inputs.affinity-nix.url = "github:mrshmllow/affinity-nix";

  den.aspects.applications = {
    os.nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    homeManager = {
      catppuccin.brave.enable = true;
    };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave-origin
          affinity-v3
          plex-desktop
          nicotine-plus
          qbittorrent
          godot-mono
        ];
        programs.zathura.enable = true;
      };

    hmDarwin =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave
          appcleaner
          thaw
        ];
      };
  };
}
