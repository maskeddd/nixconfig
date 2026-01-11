{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nil
    nixfmt
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      userSettings = {
        "catppuccin-icons.hidesExplorerArrows" = true;

        "editor.fontSize" = 16;
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "editor.formatOnSave" = true;
        "editor.semanticHighlighting.enabled" = true;
        "editor.stickyScroll.enabled" = false;

        "breadcrumbs.enabled" = false;

        "workbench.activityBar.location" = "hidden";
        "workbench.layoutControl.enabled" = false;
        "workbench.tree.stickyScroll.enabled" = false;

        "window.titleBarStyle" = "native";
        "window.menuBarVisibility" = "toggle";
        "window.customTitleBarVisibility" = "never";

        "terminal.integrated.stickyScroll.enabled" = false;
        "terminal.integrated.minimumContrastRatio" = 1;
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.profiles.linux" = {
          fish = {
            "path" = "${pkgs.fish}/bin/fish";
          };
        };

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings" = {
          nixd = {
            formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
          };
        };

        "stylua.styluaPath" = "${pkgs.stylua}/bin/stylua";

        "luau-lsp.server.path" = "${pkgs.luau-lsp}/bin/luau-lsp";
        "luau-lsp.plugin.enabled" = true;
        "luau-lsp.plugin.port" = 3667;

        "[lua]" = {
          "editor.defaultFormatter" = "JohnnyMorganz.stylua";
        };

        "[luau]" = {
          "editor.defaultFormatter" = "JohnnyMorganz.stylua";
        };
      };

      extensions = with pkgs.vscode-marketplace; [
        jnoortheen.nix-ide
        mkhl.direnv
        evaera.vscode-rojo
        johnnymorganz.luau-lsp
        johnnymorganz.stylua
        rust-lang.rust-analyzer
        tombi-toml.tombi
      ];
    };
  };
}
