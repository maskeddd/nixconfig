import { createBinding } from "ags"
import AstalBattery from "gi://AstalBattery"
import AstalPowerProfiles from "gi://AstalPowerProfiles"
import Gtk from "gi://Gtk?version=4.0"
import Divider from "./Divider"

export default function Battery() {
  const battery = AstalBattery.get_default()
  const powerprofiles = AstalPowerProfiles.get_default()

  const isPresent = createBinding(battery, "isPresent")
  const iconName = createBinding(battery, "iconName")
  const percent = createBinding(
    battery,
    "percentage",
  )((p) => `${Math.round(p * 100)}%`)

  return (
    <box visible={isPresent}>
      <Divider />
      <menubutton class="battery">
        <box spacing={4}>
          <image iconName={iconName} class="icon" />
          <label label={percent} />
        </box>
        <popover>
          <box orientation={Gtk.Orientation.VERTICAL}>
            {powerprofiles.get_profiles().map(({ profile }) => (
              <button
                onClicked={() => powerprofiles.set_active_profile(profile)}
              >
                <label label={profile} xalign={0} />
              </button>
            ))}
          </box>
        </popover>
      </menubutton>
    </box>
  )
}
