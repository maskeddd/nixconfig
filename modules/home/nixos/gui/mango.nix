{ flake, lib, ... }:
{
  imports = [ flake.inputs.mango.hmModules.mango ];

  wayland.windowManager.mango = {
    enable = true;

    settings =
      let
        moveAndSwitchTagBinds = lib.concatStringsSep "\n" (
          builtins.concatMap (n: [
            "bind=SUPER,${toString n},view,${toString n},0"
            "bind=SUPER+SHIFT,${toString n},tag,${toString n},0"
          ]) (lib.range 1 9)
        );
      in
      ''
        # startup
        exec-once=sunsetr
        exec-once=vicinae server

        # monitors
        monitorrule=DP-2,0.55,1,tile,0,1,2560,0,2560,1440,240
        monitorrule=DP-1,0.55,1,tile,0,1,0,0,2560,1440,120

        # general binds
        bind=SUPER,Return,spawn,ghostty
        bind=SUPER,r,spawn,vicinae toggle
        bind=SUPER,m,quit
        bind=SUPER,q,killclient

        # tag binds
        ${moveAndSwitchTagBinds}

        # monitor switch
        bind=SUPER,Left,focusmon,left
        bind=SUPER,Right,focusmon,right
        bind=SUPER+SHIFT,Left,tagmon,left
        bind=SUPER+SHIFT,Right,tagmon,right

        # mouse binds
        mousebind=SUPER,btn_left,moveresize,curmove
        mousebind=SUPER,btn_right,moveresize,curresize
        axisbind=SUPER,UP,viewtoleft_have_client
        axisbind=SUPER,DOWN,viewtoright_have_client

        # misc
        rag_tile_to_tile=1
      '';
  };
}
