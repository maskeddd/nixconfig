# nh: the CLI on every home, plus flake packages named after each host / home.
{ den, ... }:
{
  den.default.homeManager =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "${config.home.homeDirectory}/nixconfig";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages = den.lib.nh.denPackages { fromFlake = true; } pkgs;
    };
}
