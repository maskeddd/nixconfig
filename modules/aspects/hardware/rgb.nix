{
  den.aspects.rgb.nixos =
    { config, pkgs, ... }:
    let
      rgbScript = pkgs.writers.writePython3 "set-rgb" { } (builtins.readFile ./rgb.py);
      rgbCommand = "${rgbScript} ${pkgs.openrgb}/bin/openrgb";
    in
    {
      services.udev.packages = [ pkgs.openrgb ];
      hardware.i2c.enable = true;

      systemd.services.set-rgb = {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          StateDirectory = "openrgb";
          StateDirectoryMode = "0700";
          ExecStart = "${rgbCommand} ${config.lib.stylix.colors.base0E}";
          ExecStop = "${rgbCommand} 000000";
          Type = "oneshot";
          RemainAfterExit = true;
        };
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
      };
    };
}
