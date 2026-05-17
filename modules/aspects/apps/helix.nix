{
  den.aspects.helix.homeManager =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        extraPackages = with pkgs; [
          typstyle
          golangci-lint-langserver
          svelte-language-server
          tailwindcss-language-server
          vscode-langservers-extracted
          marksman
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
            tailwindcss-ls = {
              command = "tailwindcss-language-server";
              args = [ "--stdio" ];
            };
          };
          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
            }
            {
              name = "rust";
              auto-format = true;
            }
            {
              name = "toml";
              auto-format = true;
            }
            {
              name = "typst";
              auto-format = true;
            }
            {
              name = "java";
              auto-format = true;
            }
            {
              name = "typescript";
              language-servers = [
                "vtsls"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
            {
              name = "tsx";
              language-servers = [
                "vtsls"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
            {
              name = "javascript";
              language-servers = [
                "vtsls"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
            {
              name = "jsx";
              language-servers = [
                "vtsls"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
            {
              name = "html";
              language-servers = [
                "vscode-html-language-server"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
            {
              name = "css";
              language-servers = [
                "vscode-css-language-server"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
            {
              name = "json";
              language-servers = [ "vscode-json-language-server" ];
              auto-format = true;
            }
            {
              name = "markdown";
              language-servers = [ "marksman" ];
            }
            {
              name = "svelte";
              language-servers = [
                "svelteserver"
                "tailwindcss-ls"
              ];
              auto-format = true;
            }
          ];
        };
      };
    };
}
