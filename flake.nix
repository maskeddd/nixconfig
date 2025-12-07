{
  description = "My personal config for NixOS and nix-darwin";

  inputs = {
    # principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";

    # software inputs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    catppuccin.url = "github:catppuccin/nix";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos specific
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    vicinae.url = "github:vicinaehq/vicinae";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
    solaar.url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
    affinity-nix.url = "github:mrshmllow/affinity-nix";

    # homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    acsandmann-rift = {
      url = "github:acsandmann/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.nixos-unified.lib.mkFlake {
      inherit inputs;
      root = ./.;
    };
}
