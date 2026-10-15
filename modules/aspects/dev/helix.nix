{
  den.aspects.helix.homeManager =
    { lib, pkgs, ... }:
    let
      autoFormat =
        name: settings:
        {
          inherit name;
          auto-format = true;
        }
        // settings;
      oxfmtFormatter = {
        command = lib.getExe (
          pkgs.writeShellApplication {
            name = "oxfmt-project";
            runtimeInputs = [
              pkgs.nodejs-slim
              pkgs.oxfmt
            ];
            text = ''
              file="$PWD/$(basename "$1")"
              dir=$PWD
              while [ "$dir" != / ]; do
                if [ -x "$dir/node_modules/.bin/oxfmt" ]; then
                  exec "$dir/node_modules/.bin/oxfmt" --stdin-filepath "$file"
                fi
                dir=$(dirname "$dir")
              done
              exec oxfmt --stdin-filepath "$file"
            '';
          }
        );
        args = [ "%{buffer_name}" ];
      };
      script = {
        formatter = oxfmtFormatter;
        language-servers = [
          "vtsls"
          "oxlint"
          "tailwindcss-ls"
        ];
      };
      style = {
        formatter = oxfmtFormatter;
        language-servers = [ "tailwindcss-ls" ];
      };
      componentServers = [
        "oxlint"
        "tailwindcss-ls"
      ];
    in
    {
      programs.helix = {
        enable = true;
        extraPackages = with pkgs; [
          golangci-lint-langserver
          lua-language-server
          nixd
          oxlint
          rust-analyzer
          superhtml
          svelte-language-server
          tailwindcss-language-server
          tinymist
          tombi
          typstyle
          vscode-langservers-extracted
          vtsls
        ];
        settings = {
          editor = {
            line-number = "relative";
            cursorline = true;
            color-modes = true;
            bufferline = "multiple";
            end-of-line-diagnostics = "hint";
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            indent-guides.render = true;
            lsp.display-inlay-hints = true;
            inline-diagnostics.cursor-line = "warning";
          };
        };
        languages = {
          language-server = {
            oxlint = {
              command = "oxlint";
              args = [ "--lsp" ];
            };
            tinymist = {
              command = "tinymist";
              config = {
                formatterMode = "typstyle";
                exportPdf = "onType";
                outputPath = "$root/target/$dir/$name";
              };
            };
            vtsls = {
              command = "vtsls";
              args = [ "--stdio" ];
            };
          };
          language = lib.mapAttrsToList autoFormat {
            nix.formatter.command = lib.getExe pkgs.nixfmt;
            rust = { };
            toml.language-servers = [ "tombi" ];
            typst.soft-wrap.enable = true;

            typescript = script;
            tsx = script;
            javascript = script;
            jsx = script;

            svelte = {
              formatter = oxfmtFormatter;
              language-servers = [ "svelteserver" ] ++ componentServers;
            };
            astro.language-servers = componentServers;

            html = {
              formatter = oxfmtFormatter;
              language-servers = [
                "superhtml"
                "tailwindcss-ls"
              ];
            };
            css = style;
            scss = style;

            json.formatter = oxfmtFormatter;
            jsonc.formatter = oxfmtFormatter;
            json5.formatter = oxfmtFormatter;
            yaml.formatter = oxfmtFormatter;
            markdown.formatter = oxfmtFormatter;
            graphql.formatter = oxfmtFormatter;
          };
        };
      };
    };
}
