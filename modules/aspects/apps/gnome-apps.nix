{
  den.aspects.gnome-apps = {
    nixos = {
      nixpkgs.overlays = [
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

        xdg.mimeApps.defaultApplicationPackages = with pkgs; [
          loupe
          decibels
          showtime
          papers
          file-roller
          nautilus
        ];
      };
  };
}
