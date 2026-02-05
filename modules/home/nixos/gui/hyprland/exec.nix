{ pkgs }:
{
  exec-once = [
    "${pkgs.sunsetr}/bin/sunsetr"
    "ags run"

    "[workspace 1 silent] ${pkgs.brave}/bin/brave"
    "[workspace 3 silent] discord"
    "[workspace 4 silent] spotify"

    "steam -silent"
    "${pkgs._1password-gui}/bin/1password --silent"
  ];
}
