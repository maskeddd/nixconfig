{ inputs, ... }:
{
  flake-file.inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  den.aspects.spotify.homeManager = {
    imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];
    programs.spicetify.enable = true;
  };
}
