{ inputs, ... }:
{
  flake-file.inputs = {
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
  };

  den.aspects.ags.homeManager =
    { pkgs, ... }:
    {
      imports = [ inputs.ags.homeManagerModules.default ];

      programs.ags = {
        enable = true;
        configDir = ./_ags-shell;
        extraPackages = [
          inputs.astal.packages.${pkgs.system}.cava
          inputs.astal.packages.${pkgs.system}.hyprland
          inputs.astal.packages.${pkgs.system}.network
          inputs.astal.packages.${pkgs.system}.mpris
          inputs.astal.packages.${pkgs.system}.tray
          inputs.astal.packages.${pkgs.system}.wireplumber
          inputs.astal.packages.${pkgs.system}.notifd
          inputs.astal.packages.${pkgs.system}.battery
          inputs.astal.packages.${pkgs.system}.powerprofiles
          pkgs.libadwaita
        ];
      };
    };
}
