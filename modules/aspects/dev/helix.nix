{
  den.aspects.helix.homeManager =
    { lib, pkgs, ... }:
    let
      withOxfmt = servers: {
        language-servers = [
          {
            name = "oxfmt";
            only-features = [ "format" ];
          }
        ]
        ++ servers;
      };
      scriptServers = [
        "vtsls"
        "oxlint"
        "tailwindcss-ls"
      ];
      templFmt = pkgs.writeShellApplication {
        name = "templ-fmt-rustywind";
        runtimeInputs = [ pkgs.rustywind ];
        text = "templ fmt | rustywind --stdin --quiet";
      };
    in
    {
      programs.helix = {
        enable = true;
        extraPackages = with pkgs; [
          emmet-language-server
          lua-language-server
          nixd
          oxfmt
          oxlint
          rust-analyzer
          superhtml
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
            emmet-language-server = {
              command = "emmet-language-server";
              args = [ "--stdio" ];
            };
            oxfmt = {
              command = "oxfmt";
              args = [ "--lsp" ];
            };
            oxlint = {
              command = "oxlint";
              args = [ "--lsp" ];
            };
            tailwindcss-ls.config.tailwindCSS.includeLanguages.templ = "html";
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
          language =
            lib.mapAttrsToList
              (
                name: settings:
                {
                  inherit name;
                  auto-format = true;
                }
                // settings
              )
              (
                {
                  nix.formatter.command = lib.getExe pkgs.nixfmt;
                  rust = { };
                  toml.language-servers = [ "tombi" ];
                  typst.soft-wrap.enable = true;
                  templ.formatter.command = lib.getExe templFmt;
                  templ.language-servers = [
                    "templ"
                    {
                      name = "vscode-html-language-server";
                      except-features = [ "format" ];
                    }
                    "emmet-language-server"
                    "tailwindcss-ls"
                  ];
                  astro.language-servers = [
                    "oxlint"
                    "tailwindcss-ls"
                  ];
                }
                // lib.mapAttrs (_: withOxfmt) {
                  typescript = scriptServers;
                  tsx = scriptServers;
                  javascript = scriptServers;
                  jsx = scriptServers;
                  html = [
                    "superhtml"
                    "emmet-language-server"
                    "tailwindcss-ls"
                  ];
                  css = [ "tailwindcss-ls" ];
                  scss = [ "tailwindcss-ls" ];
                  json = [ "vscode-json-language-server" ];
                  jsonc = [ "vscode-json-language-server" ];
                  json5 = [ ];
                  yaml = [
                    "yaml-language-server"
                    "ansible-language-server"
                  ];
                  markdown = [
                    "marksman"
                    "markdown-oxide"
                  ];
                  graphql = [ "graphql-language-service" ];
                }
              );
        };
      };
    };
}
