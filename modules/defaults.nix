{ lib, den, ... }:
{
  den.default = {
    includes = [
      den.aspects.theme
      den.batteries.hostname
    ];

    os = {
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };
    };

    nixos = {
      nix.settings = {
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
      };
      services.xserver.xkb.layout = "au";
      networking.networkmanager.enable = true;
      time.timeZone = "Australia/Brisbane";
      i18n.defaultLocale = "en_AU.UTF-8";
      zramSwap.enable = true;
    };

    darwin.nix = {
      # auto-optimise-store is unreliable on macOS; optimise on a schedule instead
      optimise.automatic = true;
      settings.trusted-users = [ "@admin" ];
    };

    homeManager.home.stateVersion = "24.11";

  };

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [
    "homeManager"
    "hmLinux"
    "hmDarwin"
  ];
}
