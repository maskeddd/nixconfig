{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = false;
    mutableUserSettings = false;

    extraPackages = with pkgs; [
      nixd
      nil
      luau-lsp
      stylua
      tombi
    ];

    extensions = [
      "nix"
      "tombi"
      "scss"
      "luau"
    ];

    userSettings = {
      buffer_font_size = 16;
      buffer_font_family = "JetBrainsMono Nerd Font";

      collaboration_panel = {
        button = false;
      };
      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
      };
      agent.enabled = false;

      terminal = {
        shell.program = "fish";
      };

      languages = {
        "Nix" = {
          formatter = {
            external = {
              command = "${pkgs.nixfmt}/bin/nixfmt";
            };
          };
        };
        "Luau" = {
          formatter = {
            external = {
              command = "${pkgs.stylua}/bin/stylua";
              arguments = [ "-" ];
            };
          };
        };
      };

      lsp = {
        luau-lsp = {
          settings = {
            plugin.enabled = true;
          };
        };
      };
    };
  };
}
