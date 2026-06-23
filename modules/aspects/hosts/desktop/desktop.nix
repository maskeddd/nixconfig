{ den, ... }:
{
  den.aspects.desktop = {
    includes = with den.aspects; [
      audio
      graphics
      peripherals
      rgb
      fans
    ];
    nixos =
      { pkgs, ... }:
      {
        imports = [ ./_hardware-configuration.nix ];

        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 3;
          };
          efi.canTouchEfiVariables = true;
        };
      };

    provides.cody.nixos.users.users.cody.extraGroups = [
      "input"
      "uinput"
      "seat"
    ];
  };
}
