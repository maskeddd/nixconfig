{ inputs, ... }:
{
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    catppuccin.url = "github:catppuccin/nix";
  };

  den.aspects.theme = {
    os =
      { pkgs, ... }:
      {
        stylix = {
          enable = true;
          image = ../../assets/wallpapers/at.png;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          override = {
            base07 = "89b4fa";
            base0D = "b4befe";
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
        };
      };

    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];

        fonts.packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
        ];

        stylix.targets.chromium.enable = false;
      };
    darwin.imports = [ inputs.stylix.darwinModules.stylix ];

    homeManager = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        enable = true;
        autoEnable = false;
        accent = "lavender";
        hyprtoolkit.enable = true;
      };
    };

    hmLinux =
      { pkgs, ... }:
      {
        home.pointerCursor = {
          hyprcursor.enable = true;
          x11.enable = true;
          gtk.enable = true;
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 24;
        };
      };
  };
}
