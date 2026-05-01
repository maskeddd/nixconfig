{ den, lib, ... }:
{
  den.ctx.user.includes = [
    (
      {
        class,
        aspect-chain,
      }:
      den._.forward {
        each = [
          "Linux"
          "Darwin"
        ];
        fromClass = platform: "hm${platform}";
        intoClass = _: "homeManager";
        intoPath = _: [ ];
        fromAspect = _: lib.head aspect-chain;
        guard = { pkgs, ... }: platform: lib.mkIf pkgs.stdenv."is${platform}";
        adaptArgs =
          { config, ... }:
          {
            osConfig = config;
          };
      }
    )
  ];
}
