{ uwsm }:
{
  exec-once = [
    (uwsm "sunsetr")
    (uwsm "ags run --log-file ~/test")
    "[workspace 1 silent] ${uwsm "brave"}"
    "[workspace 3 silent] ${uwsm "discord"}"
    "[workspace 4 silent] ${uwsm "spotify"}"
    "[workspace 5 silent] ${uwsm "steam"}"
  ];
}
