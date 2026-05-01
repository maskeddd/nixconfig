{
  den.aspects.graphics.nixos =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];
      boot.kernelParams = [ "nvidia.NVreg_TemporaryFilePath=/var/tmp" ];

      environment.sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "1";
      };

      hardware = {
        graphics.enable = true;

        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          open = true;

          nvidiaSettings = true;

          package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
      };
    };
}
