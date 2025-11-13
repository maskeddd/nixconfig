import AstalWp from "gi://AstalWp"
import Gtk from "gi://Gtk?version=4.0"
import { createBinding } from "gnim"

const { defaultSpeaker: speaker } = AstalWp.get_default()!

export default function AudioOutput() {
  return (
    <menubutton class="audio">
      <box orientation={Gtk.Orientation.HORIZONTAL} spacing={4}>
        <image iconName={createBinding(speaker, "volumeIcon")} class="icon" />
        <label
          widthRequest={28}
          xalign={1}
          label={createBinding(
            speaker,
            "volume",
          )((v) => Math.round(v * 100) + "%")}
        />
      </box>
      <popover>
        <box>
          <slider
            widthRequest={260}
            onChangeValue={({ value }) => speaker.set_volume(value)}
            value={createBinding(speaker, "volume")}
          />
        </box>
      </popover>
    </menubutton>
  )
}
