{
  den.aspects.dev.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gnumake
        claude-code
        typst

        nixd
        nil
        nixfmt
        tinymist

        (pkgs.buildFHSEnv {
          name = "rider-env";
          targetPkgs =
            pkgs:
            (with pkgs; [
              jetbrains.rider
              dotnetCorePackages.dotnet_10.sdk
            ]);
          runScript = "nohup rider > /dev/null 2>&1 &";
        })
      ];
    };
}
