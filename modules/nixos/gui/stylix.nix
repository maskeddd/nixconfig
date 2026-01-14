{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";
    image = ../../../images/tree-stump.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    override = {
      base0D = "#b4befe";
      base07 = "#89b4fa";
    };

    fonts = {
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
        name = "New York";
      };

      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
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
      chromium.enable = false;
    };
  };
}
