{ den, ... }:
{
  den.aspects.cody = {
    includes =
      (with den.aspects; [
        shell
        ghostty
        dev
        git
        zed
        helix
        neovim
        spotify
        discord
        applications
        blender
        helium
        affinity
        onepassword
      ])
      ++ (with den.batteries; [
        define-user
        primary-user
        (user-shell "fish")
      ]);

    provides.desktop.includes = with den.aspects; [
      hyprland
      gaming
      obs
    ];

    provides.macbook.includes = with den.aspects; [
      rift
      roblox
    ];
  };
}
