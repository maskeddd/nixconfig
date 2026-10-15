{
  den.aspects.zed = {
    nixos.programs.nix-ld.enable = true;

    homeManager =
      { pkgs, lib, ... }:
      let
        scriptLanguages = [
          "JavaScript"
          "JSX"
          "TypeScript"
          "TSX"
          "Svelte"
        ];
        oxlintLanguages = scriptLanguages ++ [ "Astro" ];
        oxfmtLanguages = scriptLanguages ++ [
          "JSON"
          "JSON5"
          "JSONC"
          "HTML"
          "CSS"
          "SCSS"
          "LESS"
          "GraphQL"
          "Handlebars"
          "Markdown"
          "MDX"
          "YAML"
          "TOML"
        ];
      in
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
              threads_sidebar.position = "right";
              dock = "right";
            };

            agent_servers = {
              "codex-acp".type = "registry";
              "pi-acp".type = "registry";
            };

            terminal.shell.program = "fish";

            languages = lib.foldl' lib.recursiveUpdate { } [
              (lib.genAttrs oxlintLanguages (_: {
                code_actions_on_format."source.fixAll.oxc" = true;
              }))
              (lib.genAttrs oxfmtLanguages (_: {
                formatter.language_server.name = "oxfmt";
                prettier.allowed = false;
              }))
              {
                "Nix".formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
              }
            ];
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
