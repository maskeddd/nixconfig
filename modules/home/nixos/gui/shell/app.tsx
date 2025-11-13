#!/usr/bin/env -S ags run
import { createBinding, For, This } from "ags"
import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./Bar"
import GLib from "gi://GLib"
import Gtk from "gi://Gtk?version=4.0"
import NotificationPopups from "./Notifications/NotificationPopups"

let applauncher: Gtk.Window

app.start({
  css: style,
  main() {
    const monitors = createBinding(app, "monitors")

    NotificationPopups()

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
