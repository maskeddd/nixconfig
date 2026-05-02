{ inputs, ... }:
{
  flake-file.inputs = {
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

  den.aspects.homebrew.darwin =
    { config, ... }:
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

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
          "roblox"
          "robloxstudio"
          "plex"
          "helium-browser"
        ];
      };
    };
}
