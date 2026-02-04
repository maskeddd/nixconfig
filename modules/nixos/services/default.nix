{ pkgs, ... }:
{
  imports = [
    ./ly.nix
    ./solaar.nix
  ];

  services = {
    openssh.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    udev.packages = [ pkgs.vial ];
  };

  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
}
