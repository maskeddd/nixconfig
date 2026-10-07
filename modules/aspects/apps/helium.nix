{ inputs, ... }:
{
  flake-file.inputs.helium = {
    url = "github:amaanq/helium-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.helium.hmLinux =
    { pkgs, ... }:
    let
      helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium-widevine;
    in
    {
      home.packages = [ helium ];
      xdg.mimeApps.defaultApplicationPackages = [ helium ];
    };
}
