{ den, inputs, ... }:
{
  flake-file.inputs.mangowm = {
    url = "github:mangowm/mango";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.mangowm = {
    includes = with den.aspects; [ noctalia ];

    nixos = {
      imports = [ inputs.mangowm.nixosModules.mango ];

      programs.mango.enable = true;

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.mangowm.hmModules.mango ];

        home.packages = with pkgs; [ sunsetr ];

        wayland.windowManager.mango = {
          enable = true;
          systemd.variables = [ "--all" ];
          autostart_sh = ''
            sunsetr &
            mmsg dispatch viewcrossmon,3,DP-2
            steam -silent &
            1password --silent &
            brave &
            vesktop &
            spotify &
          '';
          settings = {
            monitorrule = [
              "name:^DP-2$,width:2560,height:1440,refresh:120,x:0,y:0,scale:1,rr:1"
              "name:^DP-3$,width:2560,height:1440,refresh:300,x:1440,y:560,scale:1"
            ];

            mouse_accel_profile = 1;
            mouse_accel_speed = -0.3;

            tagrule = [
              "id:3,monitor_name:DP-2,no_hide:1,layout_name:vertical_tile,mfact:0.65"
            ];

            bind = [
              "SUPER,Return,spawn,ghostty"
              "SUPER,R,spawn,noctalia msg panel-toggle launcher"
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  tag = i + 1;
                  keycode = i + 10;
                in
                [
                  "SUPER,code:${toString keycode},view,${toString tag}"
                  "SUPER+SHIFT,code:${toString keycode},tag,${toString tag}"
                ]
              ) 9
            ));
            mousebind = [
              "SUPER,btn_left,moveresize,curmove"
              "SUPER,btn_right,moveresize,curresize"
            ];
            windowrule = [
              "tags:1,isopensilent:1,istagsilent:1,appid:brave-browser"
              "tags:3,monitor:DP-2,isopensilent:1,istagsilent:1,appid:discord"
              "tags:3,monitor:DP-2,isopensilent:1,istagsilent:1,appid:vesktop"
              "tags:3,monitor:DP-2,isopensilent:1,istagsilent:1,appid:spotify"
              "tags:4,isopensilent:1,istagsilent:1,appid:steam"
            ];
          };
        };
      };
  };
}
