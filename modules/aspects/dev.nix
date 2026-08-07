{
  den.aspects.dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          typst
          nixd
        ];

        programs = {
          opencode.enable = true;
          lazygit.enable = true;
        };
        catppuccin.lazygit.enable = true;
        catppuccin.opencode.enable = true;
        stylix.targets.lazygit.enable = false;
        stylix.targets.opencode.colors.enable = false;
      };

    hmLinux =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          (buildFHSEnv {
            name = "rider-fhs";
            executableName = "rider";
            targetPkgs =
              fhsPkgs: with fhsPkgs; [
                jetbrains.rider
                dotnetCorePackages.sdk_10_0
              ];
            runScript = lib.getExe jetbrains.rider;
            extraInstallCommands = ''
              mkdir -p $out/share
              ln -s ${jetbrains.rider}/share/applications $out/share/applications
              ln -s ${jetbrains.rider}/share/icons $out/share/icons
            '';
          })
        ];
      };

    hmDarwin =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.jetbrains.rider ];
      };
  };
}
