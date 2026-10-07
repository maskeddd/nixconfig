{
  den.aspects.dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          typst
          nixd
          nixfmt
          nil
        ];

        programs = {
          opencode = {
            enable = true;
            enableMcpIntegration = true;
            settings = {
              plugin = [ "opencode-claude-auth@latest" ];
            };
          };

          mcp = {
            enable = true;
          };

          claude-code = {
            enable = true;
            enableMcpIntegration = true;
          };

          lazygit.enable = true;
          devenv.enable = true;
        };
      };

    hmLinux =
      { pkgs, lib, ... }:
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
