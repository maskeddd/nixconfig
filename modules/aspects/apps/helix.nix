{
  den.aspects.helix.homeManager =
    { pkgs, ... }:
    let
      autoFormat = name: {
        inherit name;
        auto-format = true;
      };
      withLanguageServers = name: language-servers: autoFormat name // { inherit language-servers; };
      webFormatter = {
        command = "oxfmt";
        args = [
          "--stdin-filepath"
          "%{buffer_name}"
        ];
      };
      webLanguage =
        name: language-servers: withLanguageServers name language-servers // { formatter = webFormatter; };
      typescript =
        name:
        webLanguage name [
          "vtsls"
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
          oxfmt
          oxlint
          rust-analyzer
          tailwindcss-language-server
          tinymist
          tombi
          typstyle
          vscode-langservers-extracted
          vtsls
          vue-language-server
          wgsl-analyzer
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
            tailwindcss-ls = {
              command = "tailwindcss-language-server";
              args = [ "--stdio" ];
            };
            tinymist = {
              command = "tinymist";
              config = {
                formatterMode = "typstyle";
                exportPdf = "onType";
                outputPath = "$root/target/$dir/$name";
              };
            };
            tombi = {
              command = "tombi";
              args = [ "lsp" ];
            };
            vtsls = {
              command = "vtsls";
              args = [ "--stdio" ];
            };
          };
          language = [
            (
              (autoFormat "nix")
              // {
                formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
              }
            )
            (autoFormat "rust")
            (withLanguageServers "toml" [ "tombi" ])
            (
              (autoFormat "typst")
              // {
                soft-wrap.enable = true;
              }
            )
            (typescript "typescript")
            (typescript "tsx")
            (typescript "javascript")
            (typescript "jsx")
            (webLanguage "html" [
              "vscode-html-language-server"
              "tailwindcss-ls"
            ])
            (webLanguage "css" [
              "vscode-css-language-server"
              "tailwindcss-ls"
            ])
            (webLanguage "scss" [
              "vscode-css-language-server"
              "tailwindcss-ls"
            ])
            (webLanguage "json" [ "vscode-json-language-server" ])
            (webLanguage "jsonc" [ "vscode-json-language-server" ])
            (webLanguage "vue" [
              "vuels"
              "oxlint"
              "tailwindcss-ls"
            ])
          ];
        };
      };
    };
}
