{
  den.aspects.zed = {
    nixos.programs.nix-ld.enable = true;

    homeManager =
      { pkgs, ... }:
      {
        programs.zed-editor = {
          enable = true;
          mutableUserSettings = false;

          extensions = [
            "nix"
            "tombi"
            "scss"
            "svelte"
          ];

          userSettings = {
            inlay_hints.enabled = true;

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
  };
}
