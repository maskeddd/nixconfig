import { createPoll } from "ags/time"
import GLib from "gi://GLib"
import Gtk from "gi://Gtk?version=4.0"

export default function Clock({ format = "%a %b %-d %-I:%M %p" }) {
  const time = createPoll("", 1000, () => {
    return GLib.DateTime.new_now_local().format(format)!
  })

  return (
    <menubutton class="calendar">
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}
