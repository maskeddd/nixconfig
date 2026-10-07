{
  den.aspects.applications = {
    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave-origin
          plex-desktop
          nicotine-plus
          qbittorrent
        ];

        xdg.mimeApps.defaultApplicationPackages = [ pkgs.qbittorrent ];
      };

    hmDarwin =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.appcleaner ];
      };
  };
}
