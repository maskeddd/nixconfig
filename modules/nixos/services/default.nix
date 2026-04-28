{ pkgs, ... }:
{
  imports = [
    ./solaar.nix
  ];

  services = {
    openssh.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
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
}
