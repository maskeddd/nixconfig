{
  den.aspects.zed = {
    nixos.programs.nix-ld.enable = true;

    homeManager =
      { pkgs, lib, ... }:
      let
        tsLanguages = [
          "JavaScript"
          "JSX"
          "TypeScript"
          "TSX"
        ];
        scriptLanguages = tsLanguages ++ [ "Svelte" ];
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
            "tsgo"
            "templ"
            "html"
            "emmet"
          ];

          userSettings = {
            auto_update = false;

            format_on_save = "on";

            inlay_hints.enabled = true;

            lsp.typescript-ls.settings = lib.genAttrs [ "typescript" "javascript" ] (_: {
              inlayHints =
                lib.genAttrs
                  [
                    "parameterTypes"
                    "variableTypes"
                    "propertyDeclarationTypes"
                    "functionLikeReturnTypes"
                  ]
                  (_: {
                    enabled = false;
                  });
            });

            lsp.tailwindcss-language-server.settings = {
              includeLanguages.templ = "html";
              experimental.classRegex = [
                ''class="([^"]*)"''
                ''className="([^"]*)"''
              ];
            };

            diagnostics.inline = {
              enabled = true;
              max_severity = "warning";
            };

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
              (lib.genAttrs tsLanguages (_: {
                language_servers = [
                  "typescript-ls"
                  "!vtsls"
                  "!typescript-language-server"
                  "..."
                ];
              }))
              (lib.genAttrs oxlintLanguages (_: {
                code_actions_on_format."source.fixAll.oxc" = true;
              }))
              (lib.genAttrs oxfmtLanguages (_: {
                formatter.language_server.name = "oxfmt";
                prettier.allowed = false;
              }))
              {
                "Nix".formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
                "Python".language_servers = [
                  "ty"
                  "ruff"
                ];
                "Templ".language_servers = [
                  "templ"
                  "tailwindcss-language-server"
                  "vscode-html-language-server"
                  "emmet-language-server"
                ];
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
