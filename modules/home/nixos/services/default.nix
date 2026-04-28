{
  imports = [
    ./flatpak.nix
  ];

  services = {
    polkit-gnome.enable = true;
    easyeffects.enable = true;
  };
}
