{
  imports = [
    ./stylix.nix
    ./gdm.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  qt.enable = true;
}
