{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixconfig-shell-env";
        meta.description = "Shell environment for modifying this Nix configuration";
        packages = with pkgs; [
          nixd
          nil
          nixfmt
          kdePackages.qtdeclarative
        ];
      };
    };
}
