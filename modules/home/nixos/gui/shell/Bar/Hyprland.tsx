import { Gdk, Gtk } from "ags/gtk4"
import AstalHyprland from "gi://AstalHyprland"
import { createBinding, For, With } from "gnim"
import Pango from "gi://Pango"
import Divider from "./Divider"

const hypr = AstalHyprland.get_default()

function focusWorkspace(id: number) {
  const active = hypr.focusedWorkspace

  if (active?.id !== id) {
    hypr.dispatch("workspace", id.toString())
  }
}

export function CurrentClient({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const focusedClient = createBinding(hypr, "focusedClient")((c) => {
    const model = gdkmonitor?.model
    if (!c?.monitor || !model) return null
    return c.monitor.model === model ? c : null
  })

  return (
    <With value={focusedClient}>
      {(c) =>
        c && (
          <box>
            <Divider />
            <label
              class="subtext"
              label={createBinding(c, "title") || ""}
              ellipsize={Pango.EllipsizeMode.END}
              maxWidthChars={50}
            />
          </box>
        )
      }
    </With>
  )
}

export function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const workspaces = createBinding(hypr, "workspaces")((list) => {
    const model = gdkmonitor?.model
    if (!model) return []
    return list
      .filter((w) => w.monitor?.model === model)
      .toSorted((a, b) => a.id - b.id)
  })

  return (
    <box orientation={Gtk.Orientation.HORIZONTAL}>
      <For each={workspaces}>
        {(ws) => (
          <button
            class={createBinding(hypr, "focusedWorkspace")((active) => {
              const model = gdkmonitor?.model
              if (!model) return "workspace"
              const isActive =
                active?.monitor?.model === model && ws.id === active?.id
              return isActive ? "workspace active" : "workspace"
            })}
            onClicked={() => focusWorkspace(ws.id)}
          >
            {ws.name ?? String(ws.id)}
          </button>
        )}
      </For>
    </box>
  )
}
