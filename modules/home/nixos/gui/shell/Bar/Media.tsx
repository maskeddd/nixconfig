import Gtk from "gi://Gtk?version=4.0"
import AstalMpris from "gi://AstalMpris"
import AstalCava from "gi://AstalCava"
import { createBinding, With } from "ags"
import Pango from "gi://Pango"
import Gio from "gi://Gio"

const cava = AstalCava.get_default()!
cava.framerate = 120
cava.bars = 3
cava.source = "spotify"

const blocks = "▁▂▃▄▅▆▇█".split("")

function formatDuration(seconds: number): string {
  const isNegative = seconds < 0
  const abs = Math.abs(seconds)
  const minutes = Math.floor(abs / 60)
  const secs = Math.floor(abs % 60)
    .toString()
    .padStart(2, "0")
  return `${isNegative ? "-" : ""}${minutes}:${secs}`
}

export default function Media() {
  const player = AstalMpris.Player.new("spotify")

  const position = createBinding(player, "position")
  const length = createBinding(player, "length")
  const isPlaying = createBinding(player, "playbackStatus").as(
    (s) => s === AstalMpris.PlaybackStatus.PLAYING,
  )
  const remaining = position.as((pos) => formatDuration(pos - length.get()))
  const progress = position.as((pos) =>
    length.peek() > 0 ? pos / length.peek() : 0,
  )

  return (
    <menubutton visible={createBinding(player, "available")}>
      <box>
        <box widthRequest={40} halign={Gtk.Align.CENTER} class="bars">
          <With value={isPlaying}>
            {(playing) =>
              playing ? (
                <label
                  hexpand={true}
                  label={createBinding(cava, "values").as((vals) =>
                    vals
                      .map((v) => blocks[Math.min(Math.floor(v * 8), 7)])
                      .join(""),
                  )}
                />
              ) : (
                <image
                  hexpand={true}
                  gicon={Gio.ThemedIcon.new("media-playback-start-symbolic")}
                />
              )
            }
          </With>
        </box>

        <box valign={Gtk.Align.CENTER}>
          <label label={createBinding(player, "title")} />
          <label label=" – " />
          <label label={createBinding(player, "artist")} />
        </box>
      </box>

      <popover class="media-player">
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={12}
          css="padding: 16px;"
        >
          <box spacing={18}>
            <box overflow={Gtk.Overflow.HIDDEN} class="cover-art">
              <image pixelSize={80} file={createBinding(player, "coverArt")} />
            </box>
            <box
              orientation={Gtk.Orientation.VERTICAL}
              valign={Gtk.Align.CENTER}
            >
              <label
                xalign={0}
                label={createBinding(player, "title")}
                ellipsize={Pango.EllipsizeMode.END}
                maxWidthChars={26}
              />
              <label
                class="subtext"
                xalign={0}
                label={createBinding(player, "artist")}
                ellipsize={Pango.EllipsizeMode.END}
                maxWidthChars={26}
              />
            </box>
          </box>

          <box spacing={8} class="progress">
            <label
              xalign={0}
              widthChars={5}
              label={position.as(formatDuration)}
            />
            <box>
              <slider
                widthRequest={300}
                value={progress}
                sensitive={!createBinding(player, "canSeek")}
              />
            </box>
            <label xalign={1} widthChars={5} label={remaining} />
          </box>

          <box halign={Gtk.Align.CENTER} spacing={24} class="controls">
            <button onClicked={() => player.previous()}>
              <image
                iconSize={Gtk.IconSize.LARGE}
                iconName="media-seek-backward-symbolic"
              />
            </button>
            <button onClicked={() => player.play_pause()}>
              <image
                iconSize={Gtk.IconSize.LARGE}
                iconName={createBinding(player, "playbackStatus").as((s) =>
                  s === AstalMpris.PlaybackStatus.PLAYING
                    ? "media-playback-pause-symbolic"
                    : "media-playback-start-symbolic",
                )}
              />
            </button>
            <button onClicked={() => player.next()}>
              <image
                iconSize={Gtk.IconSize.LARGE}
                iconName="media-seek-forward-symbolic"
              />
            </button>
          </box>
        </box>
      </popover>
    </menubutton>
  )
}
