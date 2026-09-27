{
  den.aspects.dev = {
    homeManager =
      { pkgs, ... }:
      let
        vinegarWine = pkgs.lib.findFirst (
          package: (package.pname or "") == "wine64"
        ) (throw "Vinegar's Wine dependency was not found") pkgs.vinegar.buildInputs;
        robloxStudioMcp = pkgs.writeShellScript "roblox-studio-mcp" ''
          data_home="''${XDG_DATA_HOME:-"$HOME/.local/share"}"
          shopt -s nullglob
          servers=("$data_home"/vinegar/versions/version-*/StudioMCP.exe)

          if (( ''${#servers[@]} != 1 )); then
            printf 'Expected one Vinegar StudioMCP.exe, found %d\n' "''${#servers[@]}" >&2
            exit 1
          fi

          export WINEPREFIX="$data_home/vinegar/prefixes/studio"
          export WINEDEBUG=-all
          exec ${pkgs.lib.getExe vinegarWine} "''${servers[0]}"
        '';
      in
      {
        home.packages = with pkgs; [
          typst
          nixd
          nil
        ];

        programs = {
          opencode = {
            enable = true;
            enableMcpIntegration = true;
          };
          mcp = {
            enable = true;
            servers = pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
              Roblox_Studio.command = "${robloxStudioMcp}";
            };
          };
          lazygit.enable = true;
          devenv.enable = true;
        };
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
        home.packages = with pkgs; [ jetbrains.rider ];
      };
  };
}
