{ flake, pkgs, ... }:
{
  imports = [
    flake.inputs.solaar.nixosModules.default
  ];

  services = {
    flatpak.enable = true;
    openssh.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager.ly = {
      enable = true;
      settings = {
        save = true;
        brightness_up_key = null;
        brightness_down_key = null;
      };
    };

    solaar = {
      enable = true;
      window = "hide";
      batteryIcons = "regular";
    };
  };

  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  security.polkit.enable = true;
}
