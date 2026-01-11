{
  imports = [
    ./keyd.nix
    ./audio.nix
    ./openrgb.nix
  ];

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    uni-sync = {
      enable = true;
      devices = [
        {
          device_id = "VID:3314/PID:41216/SN:6243168001/PATH:1-6.4:1.1";
          sync_rgb = true;
          channels = [
            {
              mode = "PWM";
              speed = 50;
            }
            {
              mode = "PWM";
              speed = 50;
            }
            {
              mode = "PWM";
              speed = 50;
            }
            {
              mode = "PWM";
              speed = 50;
            }
          ];
        }
      ];
    };
  };
}
