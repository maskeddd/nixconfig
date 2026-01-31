{ config, flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;

    user = "cody";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "acsandmann/homebrew-tap" = inputs.acsandmann-rift;
    };

    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "rift"
    ];
    casks = [
      "nordvpn"
      "cleanshot"
      "1password"
      "microsoft-word"
      "affinity"
      "appcleaner"
      "roblox"
      "robloxstudio"
      "plex"
    ];
  };
}
