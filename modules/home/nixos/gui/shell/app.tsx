#!/usr/bin/env -S ags run
import { createBinding, For, This } from "ags"
import app from "ags/gtk4/app"
import Bar from "./Bar"
import style from "./style.scss"
import Gtk from "gi://Gtk?version=4.0"

app.start({
  css: style,
  main() {
    const monitors = createBinding(app, "monitors")

    return (
      <For each={monitors} cleanup={(bar) => (bar as Gtk.Window).destroy()}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
