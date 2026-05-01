import { createBinding, For, With } from "ags"
import { Gdk } from "ags/gtk4"
import AstalHyprland from "gi://AstalHyprland"
import Pango from "gi://Pango"
import Divider from "./Divider"

const hypr = AstalHyprland.get_default()

function focusWorkspace(id: number) {
  if (hypr.focusedWorkspace?.id !== id) {
    hypr.dispatch("workspace", id.toString())
  }
}

export function CurrentClient({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const { connector } = gdkmonitor
  const focusedClient = createBinding(
    hypr,
    "focusedClient",
  )((c) => (c?.monitor?.name === connector ? c : null))

  return (
    <With value={focusedClient}>
      {(c) =>
        c && (
          <box>
            <Divider />
            <label
              class="subtext"
              label={createBinding(c, "title")}
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
  const { connector } = gdkmonitor
  const workspaces = createBinding(
    hypr,
    "workspaces",
  )((list) =>
    list
      .filter((w) => w.monitor?.name === connector)
      .toSorted((a, b) => a.id - b.id),
  )
  const focusedWorkspace = createBinding(hypr, "focusedWorkspace")

  return (
    <box>
      <For each={workspaces}>
        {(ws) => (
          <button
            class={focusedWorkspace((active) =>
              active?.monitor?.name === connector && active?.id === ws.id
                ? "workspace active"
                : "workspace",
            )}
            onClicked={() => focusWorkspace(ws.id)}
          >
            {ws.name ?? String(ws.id)}
          </button>
        )}
      </For>
    </box>
  )
}
