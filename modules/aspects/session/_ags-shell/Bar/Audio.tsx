import AstalWp from "gi://AstalWp"
import { createBinding } from "ags"

const { defaultSpeaker: speaker } = AstalWp.get_default()!

export default function AudioOutput() {
  const volumeIcon = createBinding(speaker, "volumeIcon")
  const volume = createBinding(speaker, "volume")
  const volumeLabel = volume((v) => `${Math.round(v * 100)}%`)

  return (
    <menubutton class="audio">
      <box spacing={4}>
        <image iconName={volumeIcon} class="icon" />
        <label
          class="volume-label"
          widthRequest={28}
          xalign={1}
          label={volumeLabel}
        />
      </box>
      <popover>
        <slider
          widthRequest={260}
          onChangeValue={({ value }) => speaker.set_volume(value)}
          value={volume}
        />
      </popover>
    </menubutton>
  )
}
