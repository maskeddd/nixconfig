{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    ./hardware-configuration.nix
    ./apple-silicon-support
    self.nixosModules.default
  ];

  boot = {
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
    kernelParams = [ "apple_dcp.show_notch=1" ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services = {
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = lib.mkForce false;
    };

    asahi = {
      peripheralFirmwareDirectory = ./firmware;
    };
  };

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };

  networking.hostName = "asahi";

  system.stateVersion = "25.11";
}
