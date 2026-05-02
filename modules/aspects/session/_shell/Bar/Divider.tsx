import Gtk from "gi://Gtk?version=4.0"

export default function Divider() {
  return (
    <box
      orientation={Gtk.Orientation.VERTICAL}
      class="divider"
      valign={Gtk.Align.CENTER}
    />
  )
}
