#!/usr/bin/env -S ags run
import { createBinding, For, This } from "ags"
import app from "ags/gtk4/app"
import Bar from "./Bar"
import style from "./style.scss"

app.start({
  css: style,
  main() {
    const monitors = createBinding(app, "monitors")

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
