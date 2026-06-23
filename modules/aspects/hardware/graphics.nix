{
  den.aspects.graphics.nixos = {
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.kernelParams = [ "nvidia.NVreg_TemporaryFilePath=/var/tmp" ];

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    hardware = {
      graphics.enable = true;

      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
        nvidiaSettings = true;
      };
    };
  };
}
