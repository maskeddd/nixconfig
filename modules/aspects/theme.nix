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
      };
    darwin.imports = [ inputs.stylix.darwinModules.stylix ];

    homeManager =
      { lib, ... }:
      {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];

        catppuccin = {
          accent = "lavender";
          vscode.profiles.default = {
            enable = true;
            icons.enable = true;
          };
        };

        stylix.targets = {
          zed.colors.enable = false;
          helix.enable = false;
          spicetify.enable = true;
          nixcord.enable = false;
          vscode.colors.enable = false;
        };

        programs = {
          helix.settings.theme = "catppuccin_mocha";
          nixcord.config = {
            useQuickCss = true;
            themeLinks = [
              "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/flavors/midnight-catppuccin-mocha.theme.css"
            ];
          };
          zed-editor = {
            extensions = [ "catppuccin" ];
            userSettings.theme = {
              light = "Catppuccin Latte";
              dark = "Catppuccin Mocha";
            };
          };
          vscode.profiles.default.userSettings."workbench.colorTheme" = lib.mkForce "Catppuccin Mocha";
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
