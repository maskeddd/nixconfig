{ flake, config, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Host state version; keep per-machine
  system.stateVersion = "25.05";
}
