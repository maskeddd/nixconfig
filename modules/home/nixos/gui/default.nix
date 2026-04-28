{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./ags.nix
    ./dunst.nix
    ./niri.nix
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    pointerCursor = {
      hyprcursor.enable = true;
      x11.enable = true;
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
  };
}
