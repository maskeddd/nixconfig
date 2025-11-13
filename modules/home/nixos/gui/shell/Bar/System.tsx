import { Gtk } from "ags/gtk4"
import app from "ags/gtk4/app"
import { execAsync } from "ags/process"
import Gio from "gi://Gio?version=2.0"

export function confirm(title: string, message: string, onConfirm: () => void) {
  const dialog = new Gtk.MessageDialog({
    transient_for: app.active_window,
    modal: true,
    buttons: Gtk.ButtonsType.OK_CANCEL,
    message_type: Gtk.MessageType.QUESTION,
    text: title,
    secondary_text: message,
  })

  dialog.add_css_class("power-dialog")

  dialog.connect("response", (self, response) => {
    if (response === Gtk.ResponseType.OK) onConfirm()
    self.destroy()
  })

  dialog.present()
}

const actions = {
  logout: () =>
    confirm("Log Out", "Do you really want to log out?", () =>
      execAsync("uwsm stop"),
    ),
  reboot: () =>
    confirm("Reboot", "Reboot the system now?", () =>
      execAsync("systemctl reboot"),
    ),
  shutdown: () =>
    confirm("Power Off", "Shut down the system now?", () =>
      execAsync("systemctl poweroff"),
    ),
}

for (const [name, callback] of Object.entries(actions)) {
  const act = new Gio.SimpleAction({ name })
  act.connect("activate", callback)
  app.add_action(act)
}

function createPowerMenu() {
  const menu = new Gio.Menu()

  const powerSection = new Gio.Menu()
  const rebootItem = Gio.MenuItem.new("Restart...", "app.reboot")
  const shutdownItem = Gio.MenuItem.new("Power Off...", "app.shutdown")
  powerSection.append_item(rebootItem)
  powerSection.append_item(shutdownItem)
  menu.append_section(null, powerSection)

  const sessionSection = new Gio.Menu()
  const logoutItem = Gio.MenuItem.new("Log Out...", "app.logout")
  sessionSection.append_item(logoutItem)
  menu.append_section(null, sessionSection)

  return menu
}

export default function System() {
  const menu = createPowerMenu()

  const init = (btn: Gtk.MenuButton) => {
    btn.menuModel = menu
    btn.insert_action_group("app", app)
  }

  return (
    <menubutton class="system" $={init}>
      <label class="system-icon" label="λ" />
    </menubutton>
  )
}
