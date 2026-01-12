{ config, flake, ... }:
{
  imports = [
    flake.inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;

    user = "cody";

    taps = {
      "homebrew/homebrew-core" = flake.inputs.homebrew-core;
      "homebrew/homebrew-cask" = flake.inputs.homebrew-cask;
      "acsandmann/homebrew-tap" = flake.inputs.acsandmann-rift;
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
    brews = [ "rift" ];
    casks = [
      "nordvpn"
      "cleanshot"
      "1password"
      "microsoft-word"
      "icon-composer"
      "affinity"
    ];
  };
}
