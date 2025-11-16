{
  config,
  flake,
  pkgs,
  lib,
  ...
}:
let
  uwsm = app: "uwsm app -- ${app}";
in
{
  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = flake.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      flake.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = lib.mkMerge [
      (import ./binds.nix { inherit uwsm; })
      (import ./exec.nix { inherit uwsm; })
      (import ./general.nix)
      (import ./rules.nix)
      (import ./style.nix)

      {
        cursor = {
          no_hardware_cursors = 1;
        };

        monitor = [
          "DP-2, 2560x1440@240, 2560x0, 1"
          "DP-3, 2560x1440@120.00, 0x0, 1"
        ];
      }
    ];
  };
}
