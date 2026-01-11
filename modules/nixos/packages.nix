{
  flake,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    flake.inputs.nix-vscode-extensions.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    adwaita-icon-theme
  ];
}
