{ lib, den, ... }:
{
  den.default = {
    includes = [
      den.aspects.theme
      den.provides.hostname
    ];

    os = {
      nixpkgs.config.allowUnfree = true;
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          trusted-users = [ "cody" ];
        };
      };
    };

    nixos = {
      system.stateVersion = "25.05";
      security.polkit.enable = true;
      services.openssh.enable = true;
      networking.networkmanager.enable = true;
      time.timeZone = "Australia/Brisbane";
      i18n.defaultLocale = "en_AU.UTF-8";
      services.xserver.xkb.layout = "au";
      zramSwap.enable = true;
    };

    homeManager =
      { config, ... }:
      {
        home.stateVersion = "24.11";
        programs.nh = {
          enable = true;
          flake = "${config.home.homeDirectory}/nixconfig";
        };
      };

    hmLinux.xdg.mimeApps.enable = true;
  };

  den.schema.host.includes = [
    {
      os.home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };
    }
  ];

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [
    "homeManager"
    "hmLinux"
    "hmDarwin"
  ];
  # bidirectional host<->user contributions via .provides.
  den.schema.user.includes = [ den.provides.mutual-provider ];
}
