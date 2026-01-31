{ pkgs, ... }:
let
  kanataConfig = pkgs.writeText "kanata.kbd" ''
    (defcfg
    )
    (defsrc
      esc       f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv       1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab       q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps      a    s    d    f    g    h    j    k    l    ;    '         ret
      lsft      z    x    c    v    b    n    m    ,    .    /    rsft
      fn   lctl lalt lmet           spc                 rmet ralt rctl
    )
    (deflayer qwerty
      esc       🔅   🔆   ✗    ✗    ✗    ✗    ◀◀   ▶⏸   ▶▶   🔇   🔉   🔊
      @grl      1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab       q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps      a    s    d    f    g    h    j    k    l    ;    '         ret
      lsft      z    x    c    v    b    n    m    ,    .    /    rsft
      fn   lctl lalt lmet           spc                 rmet ralt rctl
    )
    (deflayer gallium
      esc       🔅   🔆   ✗    ✗    ✗    ✗    ◀◀   ▶⏸   ▶▶   🔇   🔉   🔊
      @grl      1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab       b    l    d    c    z    j    f    o    u    ,    [    ]    \
      caps      n    r    t    s    v    y    h    a    e    i    /         ret
      lsft      q    m    w    g    x    k    p    '    ;    .    rsft
      fn   lctl lalt lmet           spc                 rmet ralt rctl
    )
    (defalias
      grl (tap-hold 200 200 grv (layer-toggle layers))
      gal (layer-switch gallium)
      qwr (layer-switch qwerty)
    )
    (deflayer layers
      _         _    _    _    _    _    _    _    _    _    _    _    _
      _         @qwr @gal _    _    _    _    _    _    _    _    _    _    _
      _         _    _    _    _    _    _    _    _    _    _    _    _    _
      _         _    _    _    _    _    _    _    _    _    _    _         _
      _         _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _              _                   _    _    _
    )
  '';
in
{
  launchd = {
    daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata -c ${kanataConfig}";
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kanata.out.log";
          StandardErrorPath = "/tmp/kanata.err.log";
        };
      };
    };
  };
}
