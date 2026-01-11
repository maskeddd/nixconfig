{ flake, ... }:

{
  imports = [ flake.inputs.nix-doom-emacs-unstraightened.homeModule ];

  services.emacs.enable = true;

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom.d;
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
}
