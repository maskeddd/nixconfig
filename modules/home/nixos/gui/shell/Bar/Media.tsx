import Gtk from "gi://Gtk?version=4.0"
import AstalMpris from "gi://AstalMpris"
import AstalCava from "gi://AstalCava"
import { createBinding, With } from "ags"
import Pango from "gi://Pango"
import Gio from "gi://Gio"

const cava = AstalCava.get_default()!
cava.framerate = 240
cava.bars = 3

const blocks = [
  "\u2581",
  "\u2582",
  "\u2583",
  "\u2584",
  "\u2585",
  "\u2586",
  "\u2587",
  "\u2588",
]

function formatDuration(seconds: number): string {
  const isNegative = seconds < 0
  const absSeconds = Math.abs(seconds)

  const minutes = Math.floor(absSeconds / 60)
  const remainingSeconds = Math.floor(absSeconds % 60)
  const paddedSeconds = remainingSeconds.toString().padStart(2, "0")

  return `${isNegative ? "-" : ""}${minutes}:${paddedSeconds}`
}

export default function Media() {
  const player = AstalMpris.Player.new("spotify")

  const position = createBinding(player, "position")
  const length = createBinding(player, "length")

  const remaining = position.as((pos) => formatDuration(pos - length.get()))

  const progress = position.as((pos) =>
    length.get() > 0 ? pos / length.get() : 0,
  )

  const isPlaying = createBinding(
    player,
    "playbackStatus",
  )((s) => s === AstalMpris.PlaybackStatus.PLAYING)

  return (
    <menubutton visible={createBinding(player, "available")}>
      <box orientation={Gtk.Orientation.HORIZONTAL}>
        <box widthRequest={40} halign={Gtk.Align.CENTER} class="bars">
          <With value={isPlaying}>
            {(i) =>
              i ? (
                <label
                  visible={isPlaying}
                  hexpand={true}
                  label={createBinding(cava, "values").as((vals) =>
                    vals
                      .map(
                        (v) =>
                          blocks[
                            Math.min(Math.floor(v * 8), blocks.length - 1)
                          ],
                      )
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

        <box valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.HORIZONTAL}>
          <label label={createBinding(player, "title")} />
          <label label=" – " />
          <label label={createBinding(player, "artist")} />
        </box>
      </box>
      <popover class="media-player">
        <box
          orientation={Gtk.Orientation.VERTICAL}
          css="padding: 16px;"
          spacing={12}
        >
          <box orientation={Gtk.Orientation.HORIZONTAL} spacing={18}>
            <box overflow={Gtk.Overflow.HIDDEN} css="border-radius: 10px;">
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
                css="font-size: 14px;"
                xalign={0}
                label={createBinding(player, "artist")}
                ellipsize={Pango.EllipsizeMode.END}
                maxWidthChars={26}
              />
            </box>
          </box>
          <box
            orientation={Gtk.Orientation.HORIZONTAL}
            spacing={8}
            class="progress"
          >
            <label
              xalign={0}
              widthChars={5}
              label={position.as((p) => formatDuration(p))}
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
          <box
            orientation={Gtk.Orientation.HORIZONTAL}
            halign={Gtk.Align.CENTER}
            spacing={24}
            class="controls"
          >
            {/*<button onClicked={() => player.shuffle()}>
              <image
                iconSize={Gtk.IconSize.LARGE}
                iconName={createBinding(player, "shuffleStatus").as((status) =>
                  status === AstalMpris.Shuffle.ON
                    ? "media-playlist-shuffle-symbolic"
                    : "media-playlist-consecutive-symbolic",
                )}
              />
            </button>*/}
            <button onClicked={() => player.previous()}>
              <image
                iconSize={Gtk.IconSize.LARGE}
                iconName="media-seek-backward-symbolic"
              />
            </button>
            <button onClicked={() => player.play_pause()}>
              <image
                iconSize={Gtk.IconSize.LARGE}
                iconName={createBinding(player, "playbackStatus").as(
                  (status) =>
                    status === AstalMpris.PlaybackStatus.PLAYING
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
