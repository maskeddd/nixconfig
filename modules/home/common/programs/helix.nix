{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      biome
      vscode-langservers-extracted
      nixd
      nil
      nixfmt
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

        indent-guides = {
          render = true;
        };

        inline-diagnostics = {
          cursor-line = "warning";
        };
      };
    };
    languages = {
      language-server = {
        biome = {
          command = "${pkgs.biome}/bin/biome";
          args = [ "lsp-proxy" ];
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "qml";
          auto-format = true;
          formatter = {
            args = [ "-E" ];
            command = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
          };
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "${pkgs.biome}/bin/biome";
            args = [
              "format"
              "--stdin-file-path"
              "file.ts"
            ];
          };
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "tsx";
          auto-format = true;
          formatter = {
            command = "${pkgs.biome}/bin/biome";
            args = [
              "format"
              "--stdin-file-path"
              "file.tsx"
            ];
          };
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = "${pkgs.biome}/bin/biome";
            args = [
              "format"
              "--stdin-file-path"
              "file.json"
            ];
          };
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
      ];
    };
  };
}
