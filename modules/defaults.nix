{ lib, den, ... }:
{
  den.default = {
    includes = [
      den.aspects.theme
      (den.lib.perHost den.provides.hostname)
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
        };

        gc = {
          automatic = true;
          dates = "weekly";
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

      boot.loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 3;
        };
        efi.canTouchEfiVariables = true;
      };
    };

    homeManager.home.stateVersion = "24.11";
  };

  den.ctx.hm-host.nixos.home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # bidirectional host<->user contributions via .provides.
  den.ctx.user.includes = [ den.provides.mutual-provider ];
}
