{ inputs, ... }:
{
  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak";

  den.aspects.flatpak = {
    nixos.services.flatpak.enable = true;

    homeManager = {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
      services.flatpak = {
        update.onActivation = true;
        uninstallUnmanaged = true;
        uninstallUnused = true;
      };
    };
  };
}
