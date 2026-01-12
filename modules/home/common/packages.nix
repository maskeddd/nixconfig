{ flake, pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages =
    with pkgs;
    [
      telegram-desktop
      qbittorrent
      jetbrains.rider
      brave

      ripgrep
      fd
      sd
      tree
      gnumake

      cachix
      nix-info
      nixpkgs-fmt
      devenv
    ]
    ++ [ flake.inputs.self.packages.${pkgs.system}.luau-lsp-proxy ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop-cuda;
    };
  };
}
