{
  imports = [
    ./obs.nix
    ./prism-launcher.nix
    ./vicinae.nix
  ];

  services.easyeffects = {
    enable = true;
  };
}
