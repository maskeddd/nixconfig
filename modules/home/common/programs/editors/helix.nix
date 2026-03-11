{ pkgs, ... }:
let
  biomeBin = "${pkgs.biome}/bin/biome";

  biomeFormatter = file: {
    command = biomeBin;
    args = [
      "format"
      "--stdin-file-path"
      file
    ];
  };
in
{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      biome
      luau-lsp
      nil
      nixd
      nixfmt
      rust-analyzer
      stylua
      tinymist
      tombi
      typstyle
      vscode-langservers-extracted
    ];

    settings = {
      theme = "nord";

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
        biome = {
          command = biomeBin;
          args = [ "lsp-proxy" ];
        };

        tinymist = {
          command = "tinymist";
          config = {
            formatterMode = "typstyle";
            exportPdf = "onType";
            outputPath = "$root/target/$dir/$name";
          };
        };
      };

      language = [
        {
          name = "json";
          auto-format = true;
          formatter = biomeFormatter "file.json";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "luau";
          auto-format = true;
          formatter = {
            command = "${pkgs.stylua}/bin/stylua";
            args = [ "-" ];
          };
        }
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
          name = "tsx";
          auto-format = true;
          formatter = biomeFormatter "file.tsx";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = biomeFormatter "file.ts";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "typst";
          auto-format = true;
        }
      ];
    };
  };
}
