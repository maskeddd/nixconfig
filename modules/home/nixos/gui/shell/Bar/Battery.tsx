import AstalBattery01 from "gi://AstalBattery"
import AstalPowerProfiles01 from "gi://AstalPowerProfiles"
import { createBinding } from "gnim"
import Gtk from "gi://Gtk?version=4.0"
import Divider from "./Divider"

export default function Battery() {
  const battery = AstalBattery01.get_default()
  const powerprofiles = AstalPowerProfiles01.get_default()

  const percent = createBinding(
    battery,
    "percentage",
  )((p) => `${Math.floor(p * 100)}%`)

  const setProfile = (profile: string) => {
    powerprofiles.set_active_profile(profile)
  }

  const isPresent = createBinding(battery, "isPresent")

  return (
    <box visible={isPresent}>
      <Divider />
      <menubutton class="battery">
        <box orientation={Gtk.Orientation.HORIZONTAL} spacing={4}>
          <image iconName={createBinding(battery, "iconName")} class="icon" />
          <label label={percent} />
        </box>
        <popover>
          <box orientation={Gtk.Orientation.VERTICAL}>
            {powerprofiles.get_profiles().map(({ profile }) => (
              <button onClicked={() => setProfile(profile)}>
                <label label={profile} xalign={0} />
              </button>
            ))}
          </box>
        </popover>
      </menubutton>
    </box>
  )
}
