{ inputs, ... }:
{
  flake-file.inputs.nix-vscode-extensions = {
    url = "github:nix-community/nix-vscode-extensions";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.vscode = {
    os.nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

    homeManager =
      { pkgs, lib, ... }:
      {
        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles.default = {
            userSettings = {
              "catppuccin-icons.hidesExplorerArrows" = true;

              "editor.fontLigatures" = true;
              "editor.minimap.enabled" = false;
              "editor.formatOnSave" = true;
              "editor.semanticHighlighting.enabled" = true;
              "editor.stickyScroll.enabled" = false;

              "breadcrumbs.enabled" = false;

              "workbench.activityBar.location" = "hidden";
              "workbench.layoutControl.enabled" = false;
              "workbench.tree.stickyScroll.enabled" = false;
              "workbench.colorTheme" = lib.mkForce "Nord";

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
            };

            extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
              jnoortheen.nix-ide
              mkhl.direnv
              tombi-toml.tombi
              ms-python.python
              ms-toolsai.jupyter
              arcticicestudio.nord-visual-studio-code
              myriad-dreamin.tinymist
            ];
          };
        };
      };
  };
}
