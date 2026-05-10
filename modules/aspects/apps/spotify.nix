{ inputs, ... }:
{
  flake-file.inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  den.aspects.spotify = {
    homeManager = {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];
      programs.spicetify.enable = true;
    };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = [
          (pkgs.writeShellScriptBin "spotify-redirect" ''
            if [[ "$1" =~ open\.spotify\.com/(track|album|playlist|artist|episode|show)/([a-zA-Z0-9]+) ]]; then
              exec ${pkgs.spotify}/bin/spotify --uri="spotify:''${BASH_REMATCH[1]}:''${BASH_REMATCH[2]}"
            fi
            exec ${pkgs.brave}/bin/brave "$1"
          '')
        ];

        xdg.desktopEntries.spotify-redirect = {
          name = "Spotify Redirect";
          exec = "spotify-redirect %u";
          mimeType = [
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];
          noDisplay = true;
        };

        xdg.mimeApps.defaultApplications = {
          "x-scheme-handler/http" = "spotify-redirect.desktop";
          "x-scheme-handler/https" = "spotify-redirect.desktop";
        };
      };
  };
}
