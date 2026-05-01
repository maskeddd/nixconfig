{
  den.aspects.rgb.nixos =
    { pkgs, ... }:
    let
      mkRgbScript =
        color:
        pkgs.writeShellScript "set-rgb" ''
          RGB="${pkgs.openrgb}/bin/openrgb"
          $RGB \
            --device 0 --mode direct --color ${color} \
            --device 1 --mode direct --color ${color} \
            --device 2 --mode direct --color ${color} \
            --device 3 --mode static --color ${color}
        '';
    in
    {
      services.udev.packages = [ pkgs.openrgb ];
      boot.kernelModules = [ "i2c-dev" ];
      hardware.i2c.enable = true;

      systemd.services.set-rgb = {
        serviceConfig = {
          ExecStart = "${mkRgbScript "81a1c1"}";
          ExecStop = "${mkRgbScript "000000"}";
          Type = "oneshot";
          RemainAfterExit = true;
        };
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
      };
    };
}
