{ pkgs }:
{
  exec-once = [
    "${pkgs.sunsetr}/bin/sunsetr"
    "ags run"

    "[workspace 1 silent] ${pkgs.brave}/bin/brave"
    "[workspace 3 silent] discord"
    "[workspace 4 silent] spotify"

    "${pkgs.steam}/bin/steam -silent"
    "${pkgs._1password-gui}/bin/1password --silent"
    "${pkgs.pkgs.openrgb-with-all-plugins}/bin/openrgb --startminimized --profile mauve"
  ];
}
