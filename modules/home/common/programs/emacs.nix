{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

  services.emacs.enable = false;

  programs.doom-emacs = {
    enable = false;
    doomDir = ./doom.d;
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
}
