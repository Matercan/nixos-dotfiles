{ inputs, pkgs, ... }:
let
  hl = "vim.api.nvim_set_hl";
  km = "vim.keymap.set";

  cmdline-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-cmdline-nvim";
    src = inputs.telescope-cmdline-nvim;
    doCheck = false;
  };

  dependsPlugin = {
    lazy = false;
    priority = 1001;
  };
in
{
  programs.nvf = {
    enable = true;

    settings = {
      vim.viAlias = true;
      vim.vimAlias = false;
      vim.globals = {
        mapleader = " ";
        mapleaderlocal = " ";
      };
      vim.options = {

        shell = "/run/current-system/sw/bin/zsh";
        shellcmdflag = "-c";
        termguicolors = true;
        encoding = "utf-8";

        foldcolumn = "1";
        foldlevel = 99;
        foldlevelstart = 99;

        splitright = true;
        clipboard = "unnamedplus";

        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;

        autoindent = true;
        copyindent = true;
        smartindent = true;

        number = true;
        cursorline = true;
        cursorlineopt = "number";
        relativenumber = true;
        wrap = false;

        undofile = true;
        undolevels = 100000;
        undoreload = 100000;
      };

      vim.treesitter = {
        enable = true;

        context.setupOpts = {
          line_numbers = true;
          max_lines = 100;
        };

        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          regex
          nix
          c
          cpp
          lua
          bash
          json
        ];

        highlight.enable = true;
        indent.enable = true;
        fold = true;
      };

      vim.lsp = {
        enable = true;

        mappings = {
          codeAction = "ca";
          documentHighlight = "lH";
          format = "lf";
          hover = "K";

          goToDeclaration = "gD";
          goToDefinition = "gd";
          goToType = "gt";

          listDocumentSymbols = "gs";
          listImplementations = "gi";
          listReferences = "gr";

          listWorkspaceFolders = "lwl";
          listWorkspaceSymbols = "lws";

          nextDiagnostic = "ln";
          openDiagnosticFloat = "le";
          previousDiagnostic = "Ln";
          renameSymbol = "lr";
          signatureHelp = "ls";
        };

      };

      vim.luaConfigRC.replace = /* lua */ ''
        ${km}('n', '<leader>rh', function()
            vim.ui.input({ prompt = 'Find: ' }, function(find_pattern)
                if not find_pattern then return end -- User cancelled

                vim.ui.input({ prompt = 'Replace with: ' }, function(replace_string)
                    replace_string = replace_string or '''

                    local cmd = '%s/' .. find_pattern .. '/' .. replace_string .. '/gc'
                    vim.cmd(cmd)
                end)
            end)
        end, { desc = 'Find and Replace (File)' })
      '';

      vim.luaConfigRC.lspconfig = /* lua */ ''
        local pid = vim.fn.getpid()

        --  Borders for floating windows
        local BORDER_STYLE = "rounded"

        vim.lsp.handlers["textDocument/hover"] =
            vim.lsp.with(vim.lsp.handlers.hover, { border = BORDER_STYLE })

        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = BORDER_STYLE })

        --  Global border override for floating previews
        vim.lsp.util.open_floating_preview = (function(original_fn)
          return function(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or BORDER_STYLE
            return original_fn(contents, syntax, opts, ...)
          end
        end)(vim.lsp.util.open_floating_preview)


        local diagSigns = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }

        --  Diagnostics configuration
        vim.diagnostic.config({
          virtual_text = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = {
            border = BORDER_STYLE,
            source = "always",
          },
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR]   = diagSigns.Error,
              [vim.diagnostic.severity.WARN] = diagSigns.Warn,
              [vim.diagnostic.severity.HINT]    = diagSigns.Hint,
              [vim.diagnostic.severity.INFO]    = diagSigns.Info,
            }
          }
        })

      '';

      vim.languages = {
        nix.enable = true;
        rust.enable = true;
        clang.enable = true;
        bash.enable = true;
        csharp.enable = true;
        json.enable = true;
        qml.enable = true;
      };

      vim.keymaps = [
        {
          key = "<leader>e";
          mode = [ "n" ];
          action = ":wq<CR>";
          desc = "Save and quit a file";
        }
        {
          key = "<leader>s";
          mode = [ "n" ];
          action = ":wa<CR>";
          desc = "Save all files";
        }
      ];

      vim.extraPlugins = {
        telescope-cmdline-nvim.package = cmdline-from-source;
      };

      vim.lazy.plugins = {
        "catppuccin-nvim" = {
          package = pkgs.vimPlugins.catppuccin-nvim;
          lazy = false;
          priority = 1000;
          setupModule = "catppuccin";

          setupOpts = {
            flavour = "macchiato";
            term_colors = true;

            styles.comments = [ "italic" ];
            styles.keywords = [ "italic" ];

            integrations = {
              gitsigns = true;
              lualine = true;
              dashboard = true;

              indent_blankline = {
                enabled = true;
                scope_color = "peach";
                colored_indent_levels = true;
              };
            };
          };

          after = /* lua */ ''
            vim.cmd("Catppuccin macchiato")

            macchiato = require("catppuccin.palettes").get_palette "macchiato"

            ${hl}(0, "Normal", { bg = "none" })  

            -- Telescope
            ${hl}(0, "TelescopeNormal", {bg = "none" })
            ${hl}(0, "TelescopeBorder", {bg = "none", fg = macchiato.blue })

            ${hl}(0, "TelescopePromptNormal", { bg = "none" })
            ${hl}(0, "TelescopePromptBorder", { bg = "none", fg = macchiato.blue })
            ${hl}(0, "TelescopePromptTitle", { bg = "none", fg = macchiato.blue })
            ${hl}(0, "TelescopeResultsNormal", { bg = "none" })
            ${hl}(0, "TelescopeResultsBorder", { bg = "none", fg = macchiato.blue })
            ${hl}(0, "TelescopePreviewNormal", { bg = "none" })
            ${hl}(0, "TelescopePreviewBorder", { bg = "none", fg = macchiato.blue }) 

            -- Line numbers                    
            ${hl}(0, "CursorLineNr", { fg = macchiato.peach, bold = true, })
            ${hl}(0, "Cursor", { fg = macchiato.lavender, })

            ${hl}(0, "Pmenu", { bg = "none" })           
            ${hl}(0, "PmenuSel", { bg = macchiato.lavender })     
            ${hl}(0, "PmenuSbar", { bg = "none" })       
            ${hl}(0, "PmenuThumb", { bg = macchiato.red })   
            ${hl}(0, "PmenuBorder", { bg = "none", fg = macchiato.blue }) 

            -- Completion item kinds (icons)
            ${hl}(0, "CmpItemKind", { fg = macchiato.red })
            ${hl}(0, "CmpItemMenu", { fg = macchiato.lavender })

            -- Float windows (for documentation)
            ${hl}(0, "NormalFloat", { bg = "none" })
            ${hl}(0, "FloatBorder", { bg = "none", fg = macchiato.blue })


          '';
        };

        "plenary.nvim" = (dependsPlugin // { package = pkgs.vimPlugins.plenary-nvim; });
        "overseer.nvim" = (dependsPlugin // { package = pkgs.vimPlugins.overseer-nvim; });
        "nvim-web-devicons" = (dependsPlugin // { package = pkgs.vimPlugins.nvim-web-devicons; });
        "mini.icons" = (dependsPlugin // { package = pkgs.vimPlugins.mini-icons; });
        "dressing.nvim" = (
          dependsPlugin
          // {
            package = pkgs.vimPlugins.dressing-nvim;
            setupModule = "dressing";
          }
        );

        "cmp-nvim-lsp" = (dependsPlugin // { package = pkgs.vimPlugins.cmp-nvim-lsp; });
        "cmp_luasnip" = (dependsPlugin // { package = pkgs.vimPlugins.cmp_luasnip; });
        "friendly-snippets" = (dependsPlugin // { package = pkgs.vimPlugins.friendly-snippets; });

        "vim-fugitive".package = pkgs.vimPlugins.vim-fugitive;
        "gitsigns.nvim".package = pkgs.vimPlugins.gitsigns-nvim;
        "vim-wakatime".package = pkgs.vimPlugins.vim-wakatime;

        "luasnip" = {
          package = pkgs.vimPlugins.luasnip;
          priority = 1000;
        };

        "indent-blankline.nvim" = {
          package = pkgs.vimPlugins.indent-blankline-nvim;
          setupModule = "ibl";
        };

        "oil.nvim" = {
          package = pkgs.vimPlugins.oil-nvim;
          setupModule = "oil";
        };

        "nvim-surround" = {
          package = pkgs.vimPlugins.nvim-surround;
          setupModule = "nvim-surround";
        };

        "mini.pairs" = {
          package = pkgs.vimPlugins.mini-pairs;

          after = /* lua */ ''
            require("mini.pairs").setup {
                modes = { insert = true, command = false, terminal = false },
                mappings = {
                    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
                    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
                    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

                    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
                    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
                    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

                    ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
                    ["'"] = { action = 'closeopen', pair = "''''", neigh_pattern = '[^%a\\].', register = { cr = false } },
                    ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
                },
            }
          '';
        };

        "nvim-cmp" = {
          package = pkgs.vimPlugins.nvim-cmp;

          after = /* lua */ ''
            local cmp = require("cmp")
            local luasnip = require("luasnip") 
            require("luasnip.loaders.from_vscode").lazy_load()

            local kind_icons = require("nvim-web-devicons").get_icons()

            local lsp_kind_icons = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰇽",
              Variable = "󰂡",
              Class = "󰠱",
              Interface = "",
              Module = "󰏗",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "󰘍",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰊄",
            }


            cmp.setup({
              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, 
              }, {
                { name = "buffer" },
              }),

              formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                  vim_item.kind = (kind_icons[vim_item.kind] or lsp_kind_icons[vim_item.kind] or "?") .. " "
                  vim_item.menu = ({
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                  })[entry.source.name]

                  return vim_item
                end,
              },
            })
          '';
        };

        "lualine.nvim" = {
          package = pkgs.vimPlugins.lualine-nvim;

          after = /* lua */ ''
            require('lualine').setup {
              options = {
                component_separators = "",
                section_separators = { left = '', right = '' },
              },
              sections = {
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
                lualine_b = { 'filename', 'branch' },
                lualine_c = {
                  '%=', --[[ add your center components here in place of this comment ]]
                },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress' },
                lualine_z = {
                  { 'location', separator = { right = '' }, left_padding = 2 },
                },
              },
              inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
              },
              tabline = {},
              extensions = {},
            }
          '';
        };

        "telescope.nvim" = {
          package = pkgs.vimPlugins.telescope-nvim;
          lazy = false;
          priority = 1000;
          setupModule = "telescope";

          setupOpts = {
            exntentions.cmdline = {
              picker.layout_config = {
                width = 480;
                height = 200;
              };
              mappings = {
                complete = "<Tab>";
                run_seleciton = "<C-CR>";
                run_input = "<CR>";
              };

              icons = {
                history = "";
                command = "";
                number = "󰉻";
                unknown = "";
              };

              prompt_prefix = "";

              overseer.enable = true;
            };
          };

          after = /* lua */ ''
            local builtin = require("telescope.builtin")

            ${km}('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            ${km}('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            ${km}('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            ${km}('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

            ${km}('n', 'Q', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
            ${km}('n', '<leader><leader>', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
          '';
        };
      };
    };
  };
}
