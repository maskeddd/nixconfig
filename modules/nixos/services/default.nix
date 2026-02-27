{ ... }:
{
  imports = [
    ./solaar.nix
  ];

  services = {
    openssh.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
  };
}
