{ inputs, ... }:
{
  flake-file.inputs.kopuz.url = "github:temidaradev/kopuz";

  den.aspects.kopuz = {
    os.nix.settings = {
      substituters = [ "https://kopuz.cachix.org" ];
      trusted-public-keys = [
        "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
      ];
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
  };
}
