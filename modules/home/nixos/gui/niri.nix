{ pkgs, ... }:
let
  niri-column-merge =
    pkgs.writers.writePython3Bin "niri-column-merge"
      {
        flakeIgnore = [ "E501" ];
      }
      ''
        import json
        import subprocess
        import time

        TARGETS = ("spotify", "discord")


        def act(*args):
            subprocess.run(["niri", "msg", "action", *args], check=False)


        def main():
            proc = subprocess.Popen(
                ["niri", "msg", "--json", "event-stream"],
                stdout=subprocess.PIPE, text=True, bufsize=1,
            )
            ids = dict.fromkeys(TARGETS)

            for line in proc.stdout:
                try:
                    ev = json.loads(line)
                except json.JSONDecodeError:
                    continue

                new = None
                if "WindowOpenedOrChanged" in ev:
                    w = ev["WindowOpenedOrChanged"]["window"]
                    if w.get("app_id") in ids and ids[w["app_id"]] != w["id"]:
                        ids[w["app_id"]] = new = w["id"]
                elif "WindowClosed" in ev:
                    for app, wid in ids.items():
                        if wid == ev["WindowClosed"]["id"]:
                            ids[app] = None

                if new and all(ids.values()):
                    time.sleep(0.3)
                    act("focus-window", "--id", str(new))
                    act("consume-or-expel-window-left")


        if __name__ == "__main__":
            try:
                main()
            except KeyboardInterrupt:
                pass
      '';

  mediaKey = cmd: {
    allow-when-locked = true;
    action.spawn = cmd;
  };
in
{
  programs.niri.settings = {
    prefer-no-csd = true;
    screenshot-path = null;

    outputs = {
      "DP-2" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 119.998;
        };
        transform.rotation = 90;
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-3" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 299.999;
        };
        position = {
          x = 1440;
          y = 560;
        };
      };
    };

    workspaces."social".open-on-output = "DP-2";

    input = {
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "10%";
      };
      mouse = {
        accel-speed = -0.3;
        accel-profile = "flat";
      };
    };

    window-rules = [
      {
        matches = [ { app-id = "^brave-browser$"; } ];
        open-on-output = "DP-3";
      }
      {
        matches = [ { app-id = "^spotify$"; } ];
        open-on-workspace = "social";
        default-column-width.proportion = 1.0;
        default-window-height.proportion = 0.5;
      }
      {
        matches = [ { app-id = "^discord$"; } ];
        open-on-workspace = "social";
        default-window-height.proportion = 0.5;
      }
      {
        matches = [
          {
            app-id = "steam";
            title = "^notificationtoasts_\\d+_desktop$";
          }
        ];
        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "bottom-right";
        };
      }
    ];

    spawn-at-startup = [
      # Helpers & services (start first so they can observe app launches).
      { argv = [ "${niri-column-merge}/bin/niri-column-merge" ]; }
      {
        argv = [
          "ags"
          "run"
        ];
      }
      { argv = [ "sunsetr" ]; }

      # Apps.
      { argv = [ "brave" ]; }
      { argv = [ "spotify" ]; }
      { argv = [ "discord" ]; }
      {
        argv = [
          "steam"
          "-silent"
        ];
      }
    ];

    binds = {
      # Spawn
      "Mod+Return".action.spawn = "ghostty";
      "Mod+E".action.spawn = "nautilus";
      "Mod+L".action.spawn = "hyprlock";
      "Mod+R".action.spawn = [
        "vicinae"
        "toggle"
      ];

      # Window / session
      "Mod+Q".action.close-window = { };
      "Mod+F".action.maximize-column = { };
      "Mod+Shift+F".action.fullscreen-window = { };
      "Mod+Shift+M".action.quit = { };

      # Screenshots
      "Print".action.screenshot-screen.show-pointer = false;
      "Shift+Print".action.screenshot.show-pointer = false;

      # Wheel — workspaces (with cooldown to avoid runaway scrolling)
      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-workspace-down = { };
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-workspace-up = { };
      };
      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-down = { };
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-up = { };
      };

      # Wheel — columns
      "Mod+WheelScrollRight".action.focus-column-right = { };
      "Mod+WheelScrollLeft".action.focus-column-left = { };
      "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
      "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

      # Shift+scroll — horizontal (mirrors app behaviour)
      "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
      "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
      "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
      "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

      # Volume
      "XF86AudioRaiseVolume" = mediaKey [
        "wpctl"
        "set-volume"
        "-l"
        "1"
        "@DEFAULT_AUDIO_SINK@"
        "2%+"
      ];
      "XF86AudioLowerVolume" = mediaKey [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "2%-"
      ];
      "XF86AudioMute" = mediaKey [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SINK@"
        "toggle"
      ];

      # Media transport
      "XF86AudioPlay" = mediaKey [
        "playerctl"
        "play-pause"
      ];
      "XF86AudioPause" = mediaKey [
        "playerctl"
        "play-pause"
      ];
      "XF86AudioNext" = mediaKey [
        "playerctl"
        "next"
      ];
      "XF86AudioPrev" = mediaKey [
        "playerctl"
        "previous"
      ];
    };
  };
}
