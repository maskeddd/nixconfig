{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        zulu21
        zulu17
      ];
    })
  ];
}
