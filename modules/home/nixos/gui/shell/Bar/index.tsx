import { onCleanup } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import app from "ags/gtk4/app"
import AudioOutput from "./Audio"
import Clock from "./Clock"
import Divider from "./Divider"
import { CurrentClient, Workspaces } from "./Hyprland"
import Media from "./Media"
import Power from "./Power"
import System from "./System"
import Tray from "./Tray"
import Wireless from "./Wireless"


const COLORS = [
  "theme_fg_color",
  "theme_text_color",
  "theme_bg_color",
  "theme_base_color",
  "theme_selected_bg_color",
  "theme_selected_fg_color",
  "insensitive_bg_color",
  "insensitive_fg_color",
  "insensitive_base_color",
  "theme_unfocused_fg_color",
  "theme_unfocused_text_color",
  "theme_unfocused_bg_color",
  "theme_unfocused_base_color",
  "theme_unfocused_selected_bg_color",
  "theme_unfocused_selected_fg_color",
  "unfocused_insensitive_color",
  "borders",
  "unfocused_borders",
]

function ThemeColors() {
  return (
    <box
      class="ThemeColors"
      orientation={Gtk.Orientation.VERTICAL}
      spacing={4}
      css={`
        padding: 8px;
      `}
    >
      {COLORS.map((name) => (
        <box
          spacing={8}
          css={`
            border-radius: 4px;
            padding: 4px 6px;
            background-color: @${name};
          `}
        >
          <label
            label={`@${name}`}
            css={`
              color: @theme_fg_color;
              font-size: 10px;
              background: rgba(0, 0, 0, 0.4);
              border-radius: 3px;
              padding: 0 4px;
            `}
          />
        </box>
      ))}
    </box>
  )
}

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  onCleanup(() => {
    win.destroy()
  })

  return (
    <window
      $={(self) => (win = self)}
      visible
      name={`bar-${gdkmonitor.connector}`}
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox cssName="centerbox">
        <box $type="start">
          <System />
          <Divider />
          <Workspaces gdkmonitor={gdkmonitor} />
          <CurrentClient gdkmonitor={gdkmonitor} />
        </box>
        <box $type="center">
          <Media />
        </box>
        <box $type="end">
          <Tray />
          <Divider />
          <AudioOutput />
          <Divider />
          <Wireless />
          <Divider />
          <Clock />
        </box>

      </centerbox>
    </window>
  )
}
