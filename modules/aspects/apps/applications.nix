{ inputs, ... }:
{
  flake-file.inputs.affinity-nix.url = "github:mrshmllow/affinity-nix";

  den.aspects.applications = {
    os.nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brave
        ];

        catppuccin.brave.enable = true;
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          affinity-v3
          plex-desktop
          nicotine-plus
          qbittorrent
          godot-mono
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
