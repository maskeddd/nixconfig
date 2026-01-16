{ pkgs, ... }:
{
  imports = [
    ./steam.nix
    ./1password.nix
  ];

  programs.fish.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
