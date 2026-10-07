{ inputs, ... }:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.neovim.homeManager =
    { pkgs, ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;
        nixpkgs.source = inputs.nixpkgs;

        globals.mapleader = " ";

        opts = {
          number = true;
          relativenumber = true;
          mouse = "a";
          clipboard = "unnamedplus";
          undofile = true;
          ignorecase = true;
          smartcase = true;
          splitbelow = true;
          splitright = true;
          signcolumn = "yes";
          completeopt = "menuone,noselect";
        };

        lsp = {
          inlayHints.enable = true;
          servers = {
            nixd = {
              enable = true;
              config.settings.nixd.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
            };
            vue_ls.enable = true;
            tailwindcss.enable = true;
            tombi.enable = true;
            vtsls = {
              enable = true;
              config = {
                filetypes = [
                  "javascript"
                  "javascriptreact"
                  "typescript"
                  "typescriptreact"
                  "vue"
                ];
                settings.vtsls.tsserver.globalPlugins = [
                  {
                    name = "@vue/typescript-plugin";
                    location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                    languages = [ "vue" ];
                    configNamespace = "typescript";
                  }
                ];
              };
            };
            oxlint.enable = true;
            oxfmt.enable = true;
            rust_analyzer.enable = true;
          };
        };

        plugins = {
          treesitter = {
            enable = true;
            highlight.enable = true;
          };

          lspconfig.enable = true;
          lsp-format = {
            enable = true;
            lspServersToEnable = [
              "nixd"
              "tombi"
              "rust_analyzer"
              "oxfmt"
            ];
            settings.nix.sync = true;
            settings.toml.exclude = [ "oxfmt" ];
          };

          ts-autotag.enable = true;

          mini-files = {
            enable = true;
            settings.windows.preview = true;
          };
          mini-pick.enable = true;
          mini-extra.enable = true;
          mini-bufremove.enable = true;

          mini-ai.enable = true;
          mini-comment.enable = true;
          mini-pairs.enable = true;
          mini-completion.enable = true;
          mini-move.enable = true;
          mini-surround = {
            enable = true;
            settings.mappings = {
              add = "gsa";
              delete = "gsd";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              replace = "gsr";
              update_n_lines = "gsn";
            };
          };

          mini-diff = {
            enable = true;
            settings.view.style = "sign";
          };
          mini-git.enable = true;

          mini-icons.enable = true;
          mini-indentscope.enable = true;
          mini-cursorword.enable = true;
          mini-hipatterns = {
            enable = true;
            settings.highlighters = {
              fixme = {
                pattern = "%f[%w]()FIXME()%f[%W]";
                group = "MiniHipatternsFixme";
              };
              hack = {
                pattern = "%f[%w]()HACK()%f[%W]";
                group = "MiniHipatternsHack";
              };
              todo = {
                pattern = "%f[%w]()TODO()%f[%W]";
                group = "MiniHipatternsTodo";
              };
              note = {
                pattern = "%f[%w]()NOTE()%f[%W]";
                group = "MiniHipatternsNote";
              };
              hex_color.__raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
            };
          };
          mini-starter.enable = true;
          mini-statusline.enable = true;
          mini-tabline.enable = true;

          mini-clue = {
            enable = true;
            settings = {
              window.delay = 300;
              triggers = [
                {
                  mode = "n";
                  keys = "<Leader>";
                }
              ];
            };
          };
        };

        keymaps =
          let
            mkKeymap = key: action: desc: {
              mode = "n";
              inherit key action;
              options = {
                inherit desc;
                silent = true;
              };
            };
          in
          [
            (mkKeymap "<C-p>" "<Cmd>Pick files<CR>" "Find files")
            (mkKeymap "<Leader>ff" "<Cmd>Pick files<CR>" "Find files")
            (mkKeymap "<Leader>fg" "<Cmd>Pick grep_live<CR>" "Search project text")
            (mkKeymap "<Leader>fb" "<Cmd>Pick buffers<CR>" "Find open buffers")
            (mkKeymap "<Leader>fr" "<Cmd>Pick oldfiles<CR>" "Find recent files")
            (mkKeymap "<Leader>fh" "<Cmd>Pick help<CR>" "Find help")
            (mkKeymap "<Leader>fk" "<Cmd>Pick keymaps<CR>" "Find keymaps")
            (mkKeymap "<Leader>e"
              "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0) ~= '' and vim.api.nvim_buf_get_name(0) or nil)<CR>"
              "Browse files beside current file"
            )
            (mkKeymap "<Leader>E" "<Cmd>lua MiniFiles.open()<CR>" "Browse working directory")
            (mkKeymap "<Leader>bd" "<Cmd>lua MiniBufremove.delete()<CR>" "Close buffer (keep splits)")
            (mkKeymap "<Leader>bn" "<Cmd>bnext<CR>" "Next buffer")
            (mkKeymap "<Leader>bp" "<Cmd>bprevious<CR>" "Previous buffer")
            (mkKeymap "<Leader>go" "<Cmd>lua MiniDiff.toggle_overlay()<CR>" "Toggle inline diff")
            (mkKeymap "<Leader>w" "<Cmd>write<CR>" "Save file")
            (mkKeymap "<Esc>" "<Cmd>nohlsearch<CR>" "Clear search highlighting")
          ];

        extraConfigLua = ''
          MiniIcons.tweak_lsp_kind('replace')
          vim.ui.select = require('mini.pick').ui_select
        '';
      };
    };
}
