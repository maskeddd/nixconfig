{ inputs, ... }:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.neovim = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.nixvim.homeModules.nixvim ];

        stylix.targets.nixvim.colors.enable = false;

        programs.nixvim = {
          enable = true;
          nixpkgs.source = inputs.nixpkgs;
          extraPackages = with pkgs; [
            fd
            nixfmt
            ripgrep
            rustfmt
            stylua
            tombi
          ];

          globals.mapleader = " ";

          opts = {
            number = true;
            relativenumber = true;
            numberwidth = 4;
            statuscolumn = "%=%{v:relnum ? v:relnum : v:lnum} %s";
            signcolumn = "yes";
          };

          keymaps = [
            {
              mode = "n";
              key = "<leader>ff";
              action = "<cmd>Pick files<cr>";
              options.desc = "Find files";
            }
            {
              mode = "n";
              key = "<leader>fg";
              action = "<cmd>Pick grep_live<cr>";
              options.desc = "Search text";
            }
            {
              mode = "n";
              key = "<leader>fb";
              action = "<cmd>Pick buffers<cr>";
              options.desc = "Find buffers";
            }
            {
              mode = "n";
              key = "<leader>fh";
              action = "<cmd>Pick help<cr>";
              options.desc = "Find help";
            }
            {
              mode = "n";
              key = "<leader>bd";
              action = "<cmd>lua MiniBufremove.delete()<cr>";
              options.desc = "Delete buffer";
            }
          ];

          diagnostic.settings = {
            signs = true;
            underline = true;
            update_in_insert = false;
            severity_sort = true;
            virtual_text = false;
          };

          colorschemes = {
            catppuccin = {
              enable = true;
              settings = {
                flavour = "mocha";
              };
            };
          };

          lsp.inlayHints.enable = true;

          lsp.servers = {
            lua_ls.enable = true;
            nixd.enable = true;
            rust_analyzer.enable = true;
            tombi.enable = true;
            tsgo.enable = true;
            vue_ls.enable = true;
          };

          plugins = {
            conform-nvim = {
              enable = true;
              settings = {
                format_on_save = {
                  lsp_format = "fallback";
                  timeout_ms = 1000;
                };
                formatters_by_ft = {
                  lua = [ "stylua" ];
                  nix = [ "nixfmt" ];
                  toml = [ "tombi" ];
                };
              };
            };

            lspconfig.enable = true;

            tiny-inline-diagnostic = {
              enable = true;
              settings = {
                preset = "modern";
                options.show_source = {
                  enabled = true;
                  if_many = true;
                };
              };
            };

            mini-ai.enable = true;
            mini-bracketed.enable = true;
            mini-bufremove.enable = true;
            mini-comment.enable = true;
            mini-completion.enable = true;
            mini-diff.enable = true;
            mini-extra.enable = true;
            mini-files.enable = true;
            mini-git.enable = true;
            mini-icons.enable = true;
            mini-indentscope.enable = true;
            mini-notify.enable = true;
            mini-operators.enable = true;
            mini-pairs.enable = true;
            mini-pick.enable = true;
            mini-snippets.enable = true;
            mini-starter.enable = true;
            mini-statusline.enable = true;
            mini-surround.enable = true;
            mini-tabline.enable = true;

            treesitter = {
              enable = true;
              highlight.enable = true;
            };
          };
        };
      };
  };
}
