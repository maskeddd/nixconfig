{
  den.aspects.blender = {
    hmLinux =
      { pkgs, lib, ... }:
      let
        blenderMcp = pkgs.python3Packages.buildPythonApplication rec {
          pname = "blender-mcp";
          version = "1.0.3";
          pyproject = true;
          src = pkgs.fetchgit {
            url = "https://projects.blender.org/lab/blender_mcp.git";
            tag = "v${version}";
            hash = "sha256-pYeByO4Oi5eyynsJhGVd1vBWXHvhGn+Y5LGit6Kazlw=";
          };
          sourceRoot = "${src.name}/mcp";
          build-system = with pkgs.python3Packages; [ setuptools ];
          dependencies = with pkgs.python3Packages; [
            docutils
            mcp
            pyyaml
          ];
          pythonImportsCheck = [ "blmcp" ];
          meta.mainProgram = "blender-mcp";
        };
      in
      {
        home.packages = [ pkgs.blender ];
        programs.mcp.servers.Blender.command = lib.getExe blenderMcp;
      };
  };
}
