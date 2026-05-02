import { createBinding, For, With } from "ags"
import AstalNetwork from "gi://AstalNetwork"
import Gtk from "gi://Gtk?version=4.0"

const network = AstalNetwork.get_default()

function sortAccessPoints(arr: AstalNetwork.AccessPoint[]) {
  return arr.filter((ap) => !!ap.ssid).sort((a, b) => b.strength - a.strength)
}

function activate(ap: AstalNetwork.AccessPoint) {
  ap.activate(null, (_, res) => {
    try {
      ap.activate_finish(res)
    } catch (error) {
      console.error(error)
    }
  })
}

export default function Wireless() {
  const wifi = createBinding(network, "wifi")

  return (
    <box visible={wifi(Boolean)}>
      <With value={wifi}>
        {(wifi) =>
          wifi && (
            <menubutton
              class="wireless"
              $={(self) => {
                self.connect("notify::active", () => {
                  if (self.active) wifi.scan()
                })
              }}
            >
              <image iconName={createBinding(wifi, "iconName")} class="icon" />
              <popover>
                <box
                  orientation={Gtk.Orientation.VERTICAL}
                  spacing={2}
                  class="wireless-list"
                >
                  <For
                    each={createBinding(
                      wifi,
                      "accessPoints",
                    )(sortAccessPoints)}
                  >
                    {(ap) => (
                      <button onClicked={() => activate(ap)}>
                        <box spacing={10}>
                          <image iconName={createBinding(ap, "iconName")} />
                          <label
                            label={createBinding(ap, "ssid")}
                            hexpand
                            xalign={0}
                          />
                          <image
                            iconName="object-select-symbolic"
                            visible={createBinding(
                              wifi,
                              "activeAccessPoint",
                            )((active) => active === ap)}
                          />
                        </box>
                      </button>
                    )}
                  </For>
                </box>
              </popover>
            </menubutton>
          )
        }
      </With>
    </box>
  )
}
