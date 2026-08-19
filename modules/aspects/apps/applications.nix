{ inputs, ... }:
{
  flake-file.inputs = {
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.applications = {
    os.nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    homeManager =
      { pkgs, ... }:
      {
        catppuccin.brave.enable = true;
        home.packages = [ inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium-widevine ];
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
