{
  den.aspects.zed = {
    nixos.programs.nix-ld.enable = true;

    homeManager =
      { pkgs, ... }:
      {
        home.shellAliases.zed = "zeditor";

        programs.zed-editor = {
          enable = true;
          mutableUserSettings = false;

          extensions = [
            "nix"
            "tombi"
            "scss"
            "oxc"
            "vue"
            "lua"
            "svelte"
          ];

          userSettings = {
            auto_update = false;

            format_on_save = "on";

            inlay_hints.enabled = true;

            collaboration_panel.button = false;
            toolbar = {
              breadcrumbs = false;
              quick_actions = false;
            };

            project_panel.dock = "left";
            git_panel.dock = "left";
            outline_panel.dock = "left";

            agent = {
              dock = "right";
              sidebar_side = "right";
            };

            agent_servers."codex-acp".type = "registry";

            terminal.shell.program = "fish";

            languages."Nix".formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
          };
        };
      };

    hmLinux =
      { pkgs, ... }:
      {
        xdg.mimeApps.defaultApplicationPackages = [ pkgs.zed-editor ];
      };
  };
}
