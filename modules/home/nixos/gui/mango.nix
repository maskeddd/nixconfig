{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.mango.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;

    settings = ''
      exec-once = vicinae server
      exec-once = sunsetr

      new_is_master=1
      default_mfact=0.55
      default_nmaster=1
      smartgaps=0

      monitorrule = DP-3,0.55,1,tile,0,1,0,0,2560,1440,120
      monitorrule = DP-2,0.55,1,tile,0,1,2560,0,2560,1440,240

      mousebind = SUPER,btn_left,moveresize,curmove
      mousebind = SUPER,btn_right,moveresize,curresize

      bind = SUPER,m,quit
      bind = SUPER,q,killclient,
      bind = SUPER,r,spawn,vicinae toggle
      bind = SUPER,Return,spawn,ghostty

      bind = SUPER,f,togglefullscreen
      bind = SUPER+SHIFT,f,togglefloating

      tagrule = id:1,layout_name:tile
      tagrule = id:2,layout_name:tile
      tagrule = id:3,layout_name:tile
      tagrule = id:4,layout_name:tile
      tagrule = id:5,layout_name:tile
      tagrule = id:6,layout_name:tile
      tagrule = id:7,layout_name:tile
      tagrule = id:8,layout_name:tile
      tagrule = id:9,layout_name:tile

      bind=SUPER,1,view,1,0
      bind=SUPER,2,view,2,0
      bind=SUPER,3,view,3,0
      bind=SUPER,4,view,4,0
      bind=SUPER,5,view,5,0
      bind=SUPER,6,view,6,0
      bind=SUPER,7,view,7,0
      bind=SUPER,8,view,8,0
      bind=SUPER,9,view,9,0

      bind=SUPER+SHIFT,1,tag,1,0
      bind=SUPER+SHIFT,2,tag,2,0
      bind=SUPER+SHIFT,3,tag,3,0
      bind=SUPER+SHIFT,4,tag,4,0
      bind=SUPER+SHIFT,5,tag,5,0
      bind=SUPER+SHIFT,6,tag,6,0
      bind=SUPER+SHIFT,7,tag,7,0
      bind=SUPER+SHIFT,8,tag,8,0
      bind=SUPER+SHIFT,9,tag,9,0
    '';
  };
}
