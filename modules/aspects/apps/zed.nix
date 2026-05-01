{
  den.aspects.zed.homeManager =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        mutableUserSettings = false;

        extraPackages = with pkgs; [
          package-version-server
        ];

        extensions = [
          "nix"
          "tombi"
          "scss"
          "nord"
        ];

        userSettings = {
          inlay_hints.enabled = true;

          theme = {
            light = "Nord Dark";
            dark = "Nord Dark";
          };

          collaboration_panel.button = false;
          toolbar = {
            breadcrumbs = false;
            quick_actions = false;
          };
          agent.enabled = false;

          terminal.shell.program = "fish";

          languages = {
            "Nix".formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
          };
        };
      };
    };
}
