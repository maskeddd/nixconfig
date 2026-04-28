{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
final: prev:
let
  packageOverlays = builtins.listToAttrs (
    builtins.attrValues (
      builtins.mapAttrs (name: _: {
        name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
        value = final.callPackage (packages + "/${name}") { };
      }) (builtins.readDir packages)
    )
  );
in
packageOverlays
// inputs.affinity-nix.overlays.default final prev
// {
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${final.system};
}
