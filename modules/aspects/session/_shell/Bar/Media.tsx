import { createBinding, With } from "ags"
import AstalCava from "gi://AstalCava"
import AstalMpris from "gi://AstalMpris"
import Gio from "gi://Gio"
import Gtk from "gi://Gtk?version=4.0"
import Pango from "gi://Pango"

const cava = AstalCava.get_default()!
cava.framerate = 120
cava.bars = 3
cava.source = "spotify"

const BLOCKS = "▁▂▃▄▅▆▇█".split("")

function formatDuration(seconds: number): string {
  const sign = seconds < 0 ? "-" : ""
  const abs = Math.abs(seconds)
  const minutes = Math.floor(abs / 60)
  const secs = Math.floor(abs % 60)
    .toString()
    .padStart(2, "0")
  return `${sign}${minutes}:${secs}`
}

export default function Media() {
  const player = AstalMpris.Player.new("spotify")

  const available = createBinding(player, "available")
  const title = createBinding(player, "title")
  const artist = createBinding(player, "artist")
  const coverArt = createBinding(player, "coverArt")
  const position = createBinding(player, "position")
  const length = createBinding(player, "length")
  const status = createBinding(player, "playbackStatus")
  const cavaValues = createBinding(cava, "values")

  const isPlaying = status((s) => s === AstalMpris.PlaybackStatus.PLAYING)
  const playPauseIcon = status((s) =>
    s === AstalMpris.PlaybackStatus.PLAYING
      ? "media-playback-pause-symbolic"
      : "media-playback-start-symbolic",
  )
  const remaining = position((pos) => formatDuration(pos - length.peek()))
  const progress = position((pos) => {
    const len = length.peek()
    return len > 0 ? pos / len : 0
  })
  const cavaLabel = cavaValues((vals) =>
    vals.map((v) => BLOCKS[Math.min(Math.floor(v * 8), 7)]).join(""),
  )

  return (
    <menubutton visible={available}>
      <box>
        <box widthRequest={40} halign={Gtk.Align.CENTER} class="bars">
          <With value={isPlaying}>
            {(playing) =>
              playing ? (
                <label hexpand label={cavaLabel} />
              ) : (
                <image
                  hexpand
                  gicon={Gio.ThemedIcon.new("media-playback-start-symbolic")}
                />
              )
            }
          </With>
        </box>

        <box valign={Gtk.Align.CENTER}>
          <label label={title} />
          <label label=" – " />
          <label label={artist} />
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
              <image pixelSize={80} file={coverArt} />
            </box>
            <box
              orientation={Gtk.Orientation.VERTICAL}
              valign={Gtk.Align.CENTER}
            >
              <label
                xalign={0}
                label={title}
                ellipsize={Pango.EllipsizeMode.END}
                maxWidthChars={26}
              />
              <label
                class="subtext"
                xalign={0}
                label={artist}
                ellipsize={Pango.EllipsizeMode.END}
                maxWidthChars={26}
              />
            </box>
          </box>

          <box spacing={8} class="progress">
            <label
              xalign={0}
              widthChars={5}
              label={position(formatDuration)}
            />
            <slider widthRequest={300} value={progress} sensitive={false} />
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
              <image iconSize={Gtk.IconSize.LARGE} iconName={playPauseIcon} />
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
