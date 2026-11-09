{
  den.aspects.dev = {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {
        home.packages = with pkgs; [
          typst
          nixd
          nixfmt
          nil
          uv
        ];

        programs = {
          mcp = {
            enable = true;
            servers = {
              cloudflare-api.url = "https://mcp.cloudflare.com/mcp";
            };
          };

          claude-code = {
            enable = true;
            enableMcpIntegration = true;
          };

          opencode = {
            enable = true;
            enableMcpIntegration = true;
            tui = lib.mkForce { };
          };

          lazygit.enable = true;
          devenv.enable = true;
        };
      };

    darwin.homebrew.casks = [ "robloxstudio" ];

    hmLinux =
      { pkgs, lib, ... }:
      {
        home.packages = with pkgs; [
          vinegar

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
