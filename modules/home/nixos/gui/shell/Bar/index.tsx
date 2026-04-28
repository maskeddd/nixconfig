import { onCleanup } from "ags"
import { Astal, Gdk } from "ags/gtk4"
import app from "ags/gtk4/app"
import AudioOutput from "./Audio"
import Battery from "./Battery"
import Clock from "./Clock"
import Divider from "./Divider"
import { CurrentClient, Workspaces } from "./Hyprland"
import Media from "./Media"
import System from "./System"
import Tray from "./Tray"
import Wireless from "./Wireless"

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
  const isLaptop = gdkmonitor.connector === "eDP-1"

  return (
    <window
      $={(self) => onCleanup(() => self.destroy())}
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
        <box $type="center">{!isLaptop && <Media />}</box>
        <box $type="end">
          {isLaptop && (
            <>
              <Divider />
              <Media />
            </>
          )}
          <Tray />
          <Battery />
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
