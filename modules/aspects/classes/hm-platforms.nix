{ den, lib, ... }:
{
  den.schema.user.includes = [
    (
      {
        class,
        aspect-chain,
      }:
      den.batteries.forward {
        each = [
          "Linux"
          "Darwin"
        ];
        fromClass = platform: "hm${platform}";
        intoClass = _: "homeManager";
        intoPath = _: [ ];
        fromAspect = _: lib.head aspect-chain;
        guard = { pkgs, ... }: platform: lib.mkIf pkgs.stdenv.hostPlatform."is${platform}";
        adaptArgs =
          { config, ... }:
          {
            osConfig = config;
          };
      }
    )
  ];
}
