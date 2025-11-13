import AstalTray from "gi://AstalTray"
import Gtk from "gi://Gtk?version=4.0"
import { createBinding, For } from "gnim"

export default function Tray() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items")

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup)
    })
  }

  return (
    <box orientation={Gtk.Orientation.HORIZONTAL}>
      <For each={items}>
        {(item) => (
          <menubutton class="tray" $={(self) => init(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  )
}
