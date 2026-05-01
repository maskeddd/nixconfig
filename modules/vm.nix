{ inputs, den, ... }:
{

  den.aspects.desktop.includes = [ (den.provides.tty-autologin "cody") ];

  den.aspects.desktop.nixos.virtualisation.vmVariant = {
    virtualisation = {
      cores = 8;
      memorySize = 8192;
      resolution = {
        x = 1920;
        y = 1080;
      };

      qemu.options = [
        "-device virtio-vga"
        "-display gtk,grab-on-hover=on,zoom-to-fit=off"
      ];
    };

    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "cody";
      };
      defaultSession = "hyprland";
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.vm = pkgs.writeShellApplication {
        name = "vm";
        text =
          let
            host = inputs.self.nixosConfigurations.desktop.config;
          in
          ''
            ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
          '';
      };
    };
}
