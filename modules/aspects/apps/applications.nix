{ inputs, ... }:
{
  flake-file.inputs.affinity-nix.url = "github:mrshmllow/affinity-nix";

  den.aspects.applications = {
    nixos.nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave
          telegram-desktop
          qbittorrent
        ];
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.affinity-v3 ];

        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "text/html" = "brave-browser.desktop";
            "x-scheme-handler/about" = "brave-browser.desktop";
            "x-scheme-handler/unknown" = "brave-browser.desktop";
          };
        };
      };

    hmDarwin =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.appcleaner ];
      };
  };
}
