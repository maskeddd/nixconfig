{ den, ... }:
{
  den.aspects.hyprland = {
    includes = with den.aspects; [
      noctalia
      hyprlock
      hypridle
    ];

    nixos = {
      nixpkgs.overlays = [
        (_final: prev: {
          hyprland = prev.hyprland.override {
            glaze = prev.glaze.overrideAttrs (_: rec {
              version = "7.9.1";
              src = prev.fetchFromGitHub {
                owner = "stephenberry";
                repo = "glaze";
                tag = "v${version}";
                hash = "sha256-NRRq5MGF2f5PW0teYnq58ELzson+U6KHVPaY6r30KLA=";
              };
            });
          };
        })
      ];

      programs.hyprland.enable = true;
      services.gnome.gnome-keyring.enable = true;
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        services.polkit-gnome.enable = true;

        home.packages = with pkgs; [
          grim
          slurp
          wl-clipboard
          playerctl
          brightnessctl
          sunsetr
        ];

        services.hyprpaper = {
          enable = true;
          settings.splash = false;
        };

        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          systemd.variables = [ "--all" ];
          configType = "lua";
          extraLuaFiles.config = ./hyprland.lua;
        };
      };
  };
}
