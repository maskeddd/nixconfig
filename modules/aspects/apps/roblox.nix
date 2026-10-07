{ den, ... }:
{
  den.aspects.roblox = {
    includes = [ den.aspects.flatpak ];

    hmLinux =
      { pkgs, lib, ... }:
      let
        vinegarWine = lib.findFirst (
          package: (package.pname or "") == "wine64"
        ) (throw "Vinegar's Wine dependency was not found") pkgs.vinegar.buildInputs;

        # Roblox Studio's MCP server, run through Vinegar's Wine prefix
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
          exec ${lib.getExe vinegarWine} "''${servers[0]}"
        '';
      in
      {
        home.packages = [ pkgs.vinegar ];
        services.flatpak.packages = [ "org.vinegarhq.Sober" ];
        programs.mcp.servers.Roblox_Studio.command = "${robloxStudioMcp}";
      };
  };
}
