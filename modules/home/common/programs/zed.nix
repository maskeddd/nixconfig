{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;

    extraPackages = with pkgs; [
      nixd
      nil
      luau-lsp
      stylua
      tombi
      luau-lsp-proxy
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
            roblox.enabled = true;
            plugin = {
              enabled = true;
              proxy_path = "${pkgs.luau-lsp-proxy}/bin/luau-lsp-proxy";
            };
          };
        };
      };
    };
  };
}
