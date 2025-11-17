{
  imports = [
    ./polkit.nix
    ./solaar.nix
  ];

  services = {
    flatpak.enable = true;
    openssh.enable = true;
    gvfs.enable = true;
  };
}
