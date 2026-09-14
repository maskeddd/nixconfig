{ inputs, ... }:
{
  flake-file.inputs = {
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.applications = {
    os.nixpkgs.overlays = [
      inputs.affinity-nix.overlays.default
      (final: prev: {
        nautilus = prev.nautilus.overrideAttrs (old: {
          buildInputs =
            old.buildInputs
            ++ (with final.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
              gst-plugins-ugly
              gst-libav
            ]);
        });
      })
    ];

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

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium-widevine
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
          appcleaner
        ];
      };
  };
}
