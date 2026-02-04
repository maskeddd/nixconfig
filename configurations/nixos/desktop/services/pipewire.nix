{ pkgs, ... }:

let
  eqConfig = ''
    Preamp: -7.1 dB
    Filter 1: ON PK Fc 35 Hz Gain 1.4 dB Q 3.97
    Filter 2: ON PK Fc 62 Hz Gain 5.8 dB Q 2.26
    Filter 3: ON PK Fc 87 Hz Gain -2.1 dB Q 2.95
    Filter 4: ON LSC Fc 103 Hz Gain 2.3 dB Q 0.70
    Filter 5: ON PK Fc 159 Hz Gain -6.1 dB Q 0.79
    Filter 6: ON PK Fc 361 Hz Gain 2.0 dB Q 2.62
    Filter 7: ON PK Fc 592 Hz Gain -1.4 dB Q 3.21
    Filter 8: ON PK Fc 1545 Hz Gain -3.5 dB Q 3.64
    Filter 9: ON PK Fc 2553 Hz Gain -2.0 dB Q 3.94
    Filter 10: ON PK Fc 3492 Hz Gain 5.2 dB Q 2.51
    Filter 11: ON PK Fc 4562 Hz Gain 1.3 dB Q 4.00
    Filter 12: ON PK Fc 5478 Hz Gain -2.3 dB Q 2.00
    Filter 13: ON PK Fc 7500 Hz Gain 4.5 dB Q 1.01
    Filter 14: ON HSC Fc 10000 Hz Gain 12.8 dB Q 0.70
    Filter 15: ON HSC Fc 13500 Hz Gain -13.4 dB Q 0.71
  '';
in
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig = {
      pipewire."10-parametric-eq" = {
        "context.modules" = [
          {
            name = "libpipewire-module-parametric-equalizer";
            args = {
              "equalizer.filepath" = pkgs.writeText "eq-config" eqConfig;
              "equalizer.description" = "Parametric EQ Sink";
            };
          }
        ];
      };
    };
  };
}
