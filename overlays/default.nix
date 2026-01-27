{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
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
packageOverlays // { }
