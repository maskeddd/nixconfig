{
  den.aspects.hypridle.homeManager =
    let
      lockCommand = "pidof hyprlock || hyprlock";
    in
    {
      services.hypridle = {
        enable = true;

        settings = {
          general = {
            lock_cmd = lockCommand;
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
            inhibit_sleep = 3;
          };

          listener = [
            {
              timeout = 300;
              on-timeout = lockCommand;
            }
            {
              timeout = 420;
              on-timeout = ''hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' '';
              on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' && brightnessctl -r'';
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    };
}
