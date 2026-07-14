{
  den.aspects.dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          claude-code
          codex
          typst

          nixd
          nil
          nixfmt
          tinymist
        ];

        programs.opencode.enable = true;
        catppuccin.opencode.enable = true;
        stylix.targets.opencode.colors.enable = false;
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = [
          (pkgs.buildFHSEnv {
            name = "rider-env";
            targetPkgs =
              pkgs:
              (with pkgs; [
                jetbrains.rider
                dotnetCorePackages.dotnet_10.sdk
              ]);
            runScript = pkgs.writeShellScript "rider-env-run" ''
              nohup rider "$@" > /dev/null 2>&1 &
            '';
          })
        ];
      };
  };
}
