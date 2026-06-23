{ inputs, ... }:
{
  flake-file.inputs.nix-vscode-extensions = {
    url = "github:nix-community/nix-vscode-extensions";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.vscode = {
    os.nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

    homeManager =
      { lib, pkgs, ... }:
      {
        catppuccin.vscode.profiles.default = {
          enable = true;
          icons.enable = true;
        };

        stylix.targets.vscode.colors.enable = false;

        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles.default = {
            userSettings = {
              "editor.fontLigatures" = true;
              "editor.minimap.enabled" = false;
              "editor.formatOnSave" = true;
              "editor.semanticHighlighting.enabled" = true;
              "editor.stickyScroll.enabled" = false;

              "breadcrumbs.enabled" = false;

              "workbench.activityBar.location" = "hidden";
              "workbench.colorTheme" = lib.mkForce "Catppuccin Mocha";
              "workbench.layoutControl.enabled" = false;

              "window.titleBarStyle" = "native";
              "window.menuBarVisibility" = "toggle";
              "window.customTitleBarVisibility" = "never";

              "terminal.integrated.minimumContrastRatio" = 1;
              "terminal.integrated.defaultProfile.linux" = "fish";
              "terminal.integrated.profiles.linux".fish.path = "${pkgs.fish}/bin/fish";

              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
              "nix.serverSettings".nixd.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];

              "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
              "qt-qml.qmlls.customExePath" = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
              "qt-qml.doNotAskForQmllsDownload" = true;
            };

            extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
              jnoortheen.nix-ide
              mkhl.direnv
              tombi-toml.tombi
              ms-python.python
              ms-toolsai.jupyter
              myriad-dreamin.tinymist
              ms-toolsai.jupyter-renderers
              theqtcompany.qt-qml
              theqtcompany.qt-core
            ];
          };
        };
      };
  };
}
