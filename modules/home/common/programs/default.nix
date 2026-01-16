{ pkgs, ... }:
{
  imports = [
    ./discord.nix
    ./emacs.nix
    ./helix.nix
    ./zed.nix
    ./vscode.nix
    ./spotify.nix
  ];

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
