{ inputs, ... }:
{
  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  den.aspects.neovim.homeManager =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      flake = ''(builtins.getFlake "${config.programs.nh.flake}")'';
      system = if pkgs.stdenv.hostPlatform.isDarwin then "darwin" else "nixos";
      host = "${flake}.${system}Configurations.${osConfig.networking.hostName}";
    in
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;

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
        };

        extraPackagesAfter = [ pkgs.nodejs-slim ];

        diagnostic.settings = {
          virtual_text.current_line = false;
          virtual_lines.current_line = true;
        };

        lsp = {
          inlayHints.enable = true;
          servers = {
            golangci_lint_ls.enable = true;
            gopls = {
              enable = true;
              package = null;
            };
            jsonls.enable = true;
            lua_ls.enable = true;
            nixd = {
              enable = true;
              config.settings.nixd = {
                formatting.command = [ (lib.getExe pkgs.nixfmt) ];
                options = {
                  ${system}.expr = "${host}.options";
                  home-manager.expr = "${host}.options.home-manager.users.valueMeta.attrs.${config.home.username}.configuration.options";
                };
              };
            };
            oxfmt.enable = true;
            oxlint.enable = true;
            rust_analyzer.enable = true;
            superhtml.enable = true;
            svelte.enable = true;
            tailwindcss.enable = true;
            tinymist = {
              enable = true;
              config.settings = {
                formatterMode = "typstyle";
                exportPdf = "onType";
                outputPath = "$root/target/$dir/$name";
              };
            };
            tombi.enable = true;
            vtsls.enable = true;
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
              "tinymist"
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
