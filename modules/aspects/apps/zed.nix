{
  den.aspects.zed = {
    nixos.programs.nix-ld.enable = true;

    homeManager =
      { pkgs, ... }:
      {
        stylix.targets.zed.colors.enable = false;

        programs.zed-editor = {
          enable = true;
          mutableUserSettings = false;

          extensions = [
            "catppuccin"
            "nix"
            "tombi"
            "scss"
            "oxc"
            "vue"
            "odin"
            "qml"
          ];

          userSettings = {
            inlay_hints.enabled = true;

            collaboration_panel.button = false;
            toolbar = {
              breadcrumbs = false;
              quick_actions = false;
            };
            agent.enabled = true;
            agent_servers."codex-acp".type = "registry";

            terminal.shell.program = "fish";

            theme = {
              light = "Catppuccin Latte";
              dark = "Catppuccin Mocha";
            };

            languages."Nix".formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
          };
        };
      };
  };
}
