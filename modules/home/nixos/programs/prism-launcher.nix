{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        zulu25
        zulu21
        zulu17
      ];
    })
  ];
}
