{ flake, pkgs, ... }:
{
  imports = [ flake.inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    image = ../../common/images/tree-stump.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    override = {
      base0D = "#b4befe";
      base07 = "#89b4fa";
    };

    fonts = {
      serif = {
        package = flake.inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
        name = "New York";
      };

      sansSerif = {
        package = flake.inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
        name = "SF Pro Text";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      zed.enable = false;
      spicetify.enable = false;
      nixcord.enable = false;
      hyprland.enable = true;
    };
  };
}
