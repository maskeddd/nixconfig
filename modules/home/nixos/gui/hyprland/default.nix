{
  lib,
  ...
}:
{
  services.hyprpaper.settings.splash = false;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = lib.mkMerge [
      (import ./binds.nix)
      (import ./exec.nix)
      (import ./general.nix)
      (import ./rules.nix)
      (import ./style.nix)

      {
        cursor = {
          no_hardware_cursors = 1;
        };

        env = [
          "NIXOS_OZONE_WL,1"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        ];

        monitor = [
          "DP-2, 2560x1440@240, 2560x0, 1"
          "DP-3, 2560x1440@120.00, 0x0, 1"
        ];
      }
    ];
  };
}
