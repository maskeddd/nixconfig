{
  den.aspects.rgb.nixos =
    { config, pkgs, ... }:
    let
      rgbScript = pkgs.writeShellScript "set-rgb" ''
        color=$1
        internal=(
          "Corsair Vengeance RGB DDR5" direct
          "EVGA GeForce RTX 3060 Ti FTW3 Ultra LHR" direct
          "ASRock Z790 Pro RS WiFi" static
        )
        keyboard=("Wooting 60HEv2" direct)
        hue=("Signify Netherlands B.V. LCL001" direct)

        set_rgb() {
          local args=()
          while (($#)); do
            args+=(--device "$1" --mode "$2" --color "$color")
            shift 2
          done
          openrgb --noautoconnect --config "$STATE_DIRECTORY" "''${args[@]}"
        }

        set_rgb "''${internal[@]}" "''${keyboard[@]}" "''${hue[@]}" && exit
        status=0
        set_rgb "''${internal[@]}" || status=1
        set_rgb "''${keyboard[@]}" || status=1
        set_rgb "''${hue[@]}" || status=1
        exit "$status"
      '';
    in
    {
      services.udev.packages = [ pkgs.openrgb ];
      hardware.i2c.enable = true;

      systemd.services.set-rgb = {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        path = [ pkgs.openrgb ];
        serviceConfig = {
          StateDirectory = "openrgb";
          StateDirectoryMode = "0700";
          ExecStart = "${rgbScript} ${config.lib.stylix.colors.base0E}";
          ExecReload = "${rgbScript} ${config.lib.stylix.colors.base0E}";
          ExecStop = "${rgbScript} 000000";
          Type = "exec";
          RemainAfterExit = true;
        };
        wantedBy = [ "multi-user.target" ];
        reloadIfChanged = true;
      };
    };
}
