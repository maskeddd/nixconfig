{ den, ... }:
{
  den.aspects.gnome = {
    includes = [ den.aspects.flatpak ];

    nixos =
      { pkgs, ... }:
      {
        services = {
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
        };

        environment.gnome.excludePackages = with pkgs; [
          gnome-tour
          gnome-user-docs
          snapshot
          yelp
          gnome-contacts
          gnome-software
          gnome-maps
          epiphany
          simple-scan
          gnome-music
          gnome-text-editor
          gnome-console
        ];
      };

    hmLinux =
      { pkgs, lib, ... }:
      let
        extractMimeTypes =
          desktopFile:
          let
            line = lib.findFirst (lib.hasPrefix "MimeType=") "" (
              lib.splitString "\n" (builtins.readFile desktopFile)
            );
          in
          lib.filter (s: s != "") (lib.splitString ";" (lib.removePrefix "MimeType=" line));
      in
      {
        xdg.mimeApps = {
          enable = true;
          defaultApplications =
            lib.genAttrs (extractMimeTypes "${pkgs.loupe}/share/applications/org.gnome.Loupe.desktop") (
              _: "org.gnome.Loupe.desktop"
            )
            // lib.genAttrs
              (extractMimeTypes "${pkgs.decibels}/share/applications/org.gnome.Decibels.desktop")
              (_: "org.gnome.Decibels.desktop");
        };
      };
  };
}
