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
        configDir = ./_shell;
        extraPackages =
          (with inputs.astal.packages.${pkgs.system}; [
            cava
            hyprland
            network
            mpris
            tray
            wireplumber
            notifd
            battery
            powerprofiles
          ])
          ++ [ pkgs.libadwaita ];
      };
    };
}
