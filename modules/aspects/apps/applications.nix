{ inputs, ... }:
{
  flake-file.inputs.affinity-nix.url = "github:mrshmllow/affinity-nix";

  den.aspects.applications = {
    os.nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    nixos = {
      programs.librepods.enable = true;
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave
          qbittorrent
          nicotine-plus
        ];
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          affinity-v3
          plex-desktop
          libreoffice
          hunspell
          hunspellDicts.en-au
        ];

        xdg.mimeApps.defaultApplications = {
          "text/html" = "brave-browser.desktop";
          "x-scheme-handler/about" = "brave-browser.desktop";
          "x-scheme-handler/unknown" = "brave-browser.desktop";
        };
      };

    hmDarwin =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.appcleaner ];
      };
  };
}
