import { createBinding, For } from "ags"
import AstalTray from "gi://AstalTray"
import Gtk from "gi://Gtk?version=4.0"

function bindMenu(btn: Gtk.MenuButton, item: AstalTray.TrayItem) {
  btn.menuModel = item.menuModel
  btn.insert_action_group("dbusmenu", item.actionGroup)
  item.connect("notify::action-group", () => {
    btn.insert_action_group("dbusmenu", item.actionGroup)
  })
}

export default function Tray() {
  const items = createBinding(AstalTray.get_default(), "items")

  return (
    <box>
      <For each={items}>
        {(item) => (
          <menubutton class="tray" $={(self) => bindMenu(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  )
}
