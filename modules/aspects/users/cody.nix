{ den, ... }:
{
  den.aspects.cody = {
    includes = with den; [
      aspects.shell
      aspects.dev
      aspects.git
      aspects.zed
      aspects.helix
      aspects.neovim
      aspects.spotify
      aspects.discord
      aspects.applications
      aspects.onepassword
      provides.define-user
      provides.primary-user
      (provides.user-shell "fish")
    ];

    provides.desktop.includes = with den.aspects; [
      hyprland
      mangowm
      gaming
      gnome
      obs
      audio
    ];

    provides.macbook.includes = [ den.aspects.rift ];
  };
}
