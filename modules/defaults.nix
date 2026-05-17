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

          substituters = [
            "https://ezkea.cachix.org"
            "https://cache.garnix.io"
          ];

          trusted-public-keys = [
            "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          ];

          trusted-users = [ "cody" ];
        };
      };
    };

    nixos =
      { pkgs, ... }:
      {
        system.stateVersion = "25.05";

        programs.nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "--keep 3 --keep-since 7d";
          };
        };

        security.polkit.enable = true;

        services.openssh.enable = true;

        networking.networkmanager.enable = true;

        time.timeZone = "Australia/Brisbane";
        i18n.defaultLocale = "en_AU.UTF-8";
        i18n.extraLocaleSettings = {
          LC_ADDRESS = "en_AU.UTF-8";
          LC_IDENTIFICATION = "en_AU.UTF-8";
          LC_MEASUREMENT = "en_AU.UTF-8";
          LC_MONETARY = "en_AU.UTF-8";
          LC_NAME = "en_AU.UTF-8";
          LC_NUMERIC = "en_AU.UTF-8";
          LC_PAPER = "en_AU.UTF-8";
          LC_TELEPHONE = "en_AU.UTF-8";
          LC_TIME = "en_AU.UTF-8";
        };

        services.xserver.xkb = {
          layout = "au";
          variant = "";
        };

        boot.kernelPackages = pkgs.linuxPackages_latest;

        boot.loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 3;
          };
          efi.canTouchEfiVariables = true;
        };

        zramSwap.enable = true;

        # zram caps RAM hard; rely on userspace OOM to avoid lockups
        systemd.oomd.enable = true;
      };

    homeManager.home.stateVersion = "24.11";

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
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # bidirectional host<->user contributions via .provides.
  den.schema.user.includes = [ den.provides.mutual-provider ];
}
