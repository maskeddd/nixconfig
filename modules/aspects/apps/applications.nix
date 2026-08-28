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

    nixos = {
      programs = {
        gnome-disks.enable = true;
        seahorse.enable = true;
      };

      services = {
        gnome = {
          evolution-data-server.enable = true;
          sushi.enable = true;
        };
        gvfs.enable = true;
      };
    };

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

          baobab
          decibels
          gnome-calculator
          gnome-calendar
          gnome-clocks
          gnome-font-viewer
          loupe
          nautilus
          papers
          showtime
          file-roller
        ];
        programs.zathura.enable = true;

        xdg.mimeApps = {
          enable = true;
          defaultApplicationPackages = [
            pkgs.loupe
            pkgs.decibels
            pkgs.showtime
            pkgs.papers
            pkgs.file-roller
            pkgs.nautilus
            pkgs.qbittorrent
            pkgs.zed-editor
            inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium-widevine
          ];
        };
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
