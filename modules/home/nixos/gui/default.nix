# A module that automatically imports only .nix files (excluding default.nix)
{
  imports = [
    ./ags.nix
    ./gtk.nix
    ./stylix.nix
    ./hypr
  ];
}
