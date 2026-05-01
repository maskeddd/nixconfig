{ den, ... }:
{
  den.aspects.cody = {
    includes = with den; [
      aspects.shell
      aspects.dev
      aspects.git
      aspects.zed
      aspects.vscode
      aspects.spotify
      aspects.discord
      aspects.applications
      aspects.onepassword
      provides.define-user
      provides.primary-user
      (provides.user-shell "fish")
    ];

    provides.desktop = {
      includes = with den.aspects; [
        hyprland
        gaming
        gnome
        obs
      ];
      nixos.users.users.cody.extraGroups = [
        "input"
        "uinput"
        "seat"
      ];
    };
  };
}
