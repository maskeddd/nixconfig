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
        ];
      };
  };
}
