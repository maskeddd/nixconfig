{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
  nix-vscode-extensions = system: inputs.nix-vscode-extensions.extensions.${system};
in
self: super:
let

  entries = builtins.readDir packages;

  makePackage =
    name: type:
    let
      pkgName =
        if type == "regular" && builtins.match ".*\\.nix$" name != null then
          builtins.replaceStrings [ ".nix" ] [ "" ] name
        else
          name;
    in
    {
      name = pkgName;
      value = self.callPackage (packages + "/${name}") { };
    };

  packageOverlays = builtins.listToAttrs (
    builtins.attrValues (builtins.mapAttrs makePackage entries)
  );

in
packageOverlays
// {
  nix-vscode-extensions = nix-vscode-extensions self.system;
}
