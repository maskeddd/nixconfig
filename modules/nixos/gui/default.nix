{
  imports = [
    ./gdm.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
