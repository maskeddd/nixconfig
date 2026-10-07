{ den, ... }:
{
  den.hosts.x86_64-linux.desktop = {
    users.cody = { };
    primaryMonitor = "DP-3";
  };

  den.aspects.desktop = {
    includes = with den.aspects; [
      audio
      graphics
      peripherals
      rgb
      fans
      mullvad
    ];
    nixos =
      { pkgs, ... }:
      {
        imports = [ ./_hardware-configuration.nix ];

        system.stateVersion = "25.05";

        environment.etc."xdg/monitors.xml".source = ./monitors.xml;

        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 3;
          };
          efi.canTouchEfiVariables = true;
        };
      };

    provides.to-users.user.extraGroups = [
      "input"
      "uinput"
      "seat"
    ];
  };
}
