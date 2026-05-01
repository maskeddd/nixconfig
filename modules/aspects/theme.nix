{ inputs, ... }:
let
  mkStylixConfig = pkgs: {
    enable = true;
    polarity = "dark";
    image = ../../assets/wallpapers/nord-abstract.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
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
in
{
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  den.aspects.theme = {
    os =
      { pkgs, ... }:
      {
        stylix = mkStylixConfig pkgs;
      };
    nixos.imports = [ inputs.stylix.nixosModules.stylix ];
    darwin.imports = [ inputs.stylix.darwinModules.stylix ];

    homeManager.stylix.targets = {
      zed = {
        colors.enable = false;
      };
      spicetify.enable = true;
      nixcord.enable = false;
      helix.enable = false;
      vscode.colors.enable = false;
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
