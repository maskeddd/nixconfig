{ pkgs, ... }:
{
  imports = [
    ./hyprland
    ./hypridle.nix
    ./hyprlock.nix
    ./ags.nix
    ./stylix.nix
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
  };

  services.polkit-gnome.enable = true;
}
