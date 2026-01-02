{
  config,
  inputs,
  pkgs,
  ...
}:
let
  hl = "vim.api.nvim_set_hl";
  km = "vim.keymap.set";
  plug = pkgs.vimPlugins;

  colors = config.colors-hex;

  cmdline-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-cmdline-nvim";
    src = inputs.telescope-cmdline-nvim;
    doCheck = false;
  };

  fzf-native-from-source = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-fzf-native";
    src = inputs.telescope-fzf-native;
    doCheck = false;
    buildPhase = /* shell */ ''make '';
    nativeBuildInputs = [
      pkgs.gnumake
      pkgs.gcc
    ];
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
        winborder = "single";

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

      vim.luaConfigRC.opts = /* lua */ ''
        vim.opt.clipboard = "unnamedplus"
        vim.opt.splitright = true
        vim.opt.winborder = "single"
        vim.opt.foldmethod = "expr"
      '';

      vim.treesitter = {
        enable = true;

        context.setupOpts = {
          line_numbers = true;
          max_lines = 100;
        };

        grammars = with plug.nvim-treesitter.builtGrammars; [
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

      vim.ui.borders = {
        globalStyle = "single";
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
        local BORDER_STYLE = "single"

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
          action = ":q<CR>";
          desc = "quit a buffer";
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
        telescope-fzf-native.package = fzf-native-from-source;
      };

      vim.lazy.plugins = {
        "catppuccin-nvim" = {
          package = plug.catppuccin-nvim;
          lazy = false;
          priority = 1000;
          setupModule = "catppuccin";

          setupOpts = {
            flavour = "macchiato";
            term_colors = true;
            transparent = true;

            styles.comments = [ "italic" ];
            styles.keywords = [
              "italic"
              "bold"
            ];
            styles.operators = [ "italic" ];

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

            color_overrides = {
              all = {
                text = colors.text;
                base = colors.background;
                mantle = colors.background;
                crust = colors.border;

                surface0 = colors.background;
                surface1 = colors.selection;
                surface2 = colors.accent;

                rosewater = colors.regular1;
                flamingo = colors.regular1;
                pink = colors.regular4;
                mauve = colors.regular4;
                red = colors.bright1;
                maroon = colors.regular1;
                peach = colors.regular3;
                yellow = colors.bright3;
                green = colors.regular2;
                teal = colors.regular6;
                sky = colors.bright4;
                sapphire = colors.bright4;
                blue = colors.regular4;
                lavender = colors.regular5;

                subtext1 = colors.secondary_text;
                subtext0 = colors.foreground;
                overlay2 = colors.selection_background;
                overlay1 = colors.selection;
                overlay0 = colors.selection;
              };
            };
          };

          after = /* lua */ ''
            vim.cmd("Catppuccin macchiato")

            macchiato = require("catppuccin.palettes").get_palette "macchiato"

            ${hl}(0, "Normal", { bg = "none" })  
            ${hl}(0, "NormalNC", { bg = "none" })

            -- Telescope (add TelescopeSelection)
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none", fg = macchiato.blue })
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none", fg = macchiato.blue })
            vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none", fg = macchiato.blue })
            vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
            vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none", fg = macchiato.blue })
            vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
            vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none", fg = macchiato.blue })

            -- Add these for full transparency
            vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "none", fg = macchiato.peach, bold = true })
            vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { bg = "none", fg = macchiato.peach })
            -- Line numbers                    
            ${hl}(0, "CursorLineNr", { fg = macchiato.peach, bold = true, })
            ${hl}(0, "Cursor", { fg = macchiato.lavender, })

            ${hl}(0, "Pmenu", { bg = "none" })           
            ${hl}(0, "PmenuSel", { bg = macchiato.lavender })     
            ${hl}(0, "PmenuSbar", { bg = "none" })       
            ${hl}(0, "PmenuThumb", { bg = macchiato.red })   
            ${hl}(0, "PmenuBorder", { bg = "none", fg = macchiato.blue }) 

            -- Completion item kinds (icons)
            ${hl}(0, "CmpItemKind", { bg = "none", fg = macchiato.red })
            ${hl}(0, "CmpItemMenu", { bg = "none", fg = macchiato.lavender })

            -- Float windows (for documentation)
            ${hl}(0, "NormalFloat", { bg = "none" })
            ${hl}(0, "FloatBorder", { bg = "none", fg = macchiato.blue })
          '';
        };

        "plenary.nvim" = (dependsPlugin // { package = plug.plenary-nvim; });
        "overseer.nvim" = (dependsPlugin // { package = plug.overseer-nvim; });
        "nvim-web-devicons" = (dependsPlugin // { package = plug.nvim-web-devicons; });
        "mini.icons" = (dependsPlugin // { package = plug.mini-icons; });
        "dressing.nvim" = (
          dependsPlugin
          // {
            package = plug.dressing-nvim;
            setupModule = "dressing";

            setupOpts = {
              input.border = "single";
              select.backend = [
                "telescope"
                "fzf"
                "builtin"
              ];
            };
          }
        );

        "cmp-nvim-lsp" = (dependsPlugin // { package = plug.cmp-nvim-lsp; });
        "cmp_luasnip" = (dependsPlugin // { package = plug.cmp_luasnip; });
        "friendly-snippets" = (dependsPlugin // { package = plug.friendly-snippets; });

        "vim-fugitive".package = plug.vim-fugitive;
        "gitsigns.nvim".package = plug.gitsigns-nvim;
        "vim-wakatime".package = plug.vim-wakatime;

        "luasnip" = {
          package = plug.luasnip;
          priority = 1000;
        };

        "indent-blankline.nvim" = {
          package = plug.indent-blankline-nvim;
          setupModule = "ibl";
        };

        "oil.nvim" = {
          package = plug.oil-nvim;
          setupModule = "oil";
        };

        "nvim-surround" = {
          package = plug.nvim-surround;
          setupModule = "nvim-surround";
        };

        "mini.pairs" = {
          package = plug.mini-pairs;

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
          package = plug.nvim-cmp;

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
          package = plug.lualine-nvim;

          after = /* lua */ ''
            require('lualine').setup({
                options = {
                  icons_enabled = true,
                  theme = 'auto',
                  component_separators = { left = '|', right = '|'},
                  section_separators = { left = "", right = ""},
                  disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                  },
                  ignore_focus = {},
                  always_divide_middle = true,
                  globalstatus = false,
                  refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                  }
                },
                sections = {
                  lualine_a = {'mode'},
                  lualine_b = {'branch'},
                  lualine_c = {
                    {
                      'filename',
                      path = 0, -- just filename
                    }
                  },
                  lualine_x = {'encoding', 'diff', 'filetype'},
                  lualine_y = {'location'},
                  lualine_z = {'progress'}
                },
                inactive_sections = {
                  lualine_a = {},
                  lualine_b = {},
                  lualine_c = {'filename'},
                  lualine_x = {'location'},
                  lualine_y = {},
                  lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
              })
          '';
        };

        "telescope.nvim" = {
          package = plug.telescope-nvim;
          lazy = false;
          priority = 1000;
          setupModule = "telescope";

          setupOpts = {
            defaults.borderchars = [
              "─"
              "│"
              "─"
              "│"
              "┌"
              "┐"
              "┘"
              "└"
            ];

            extensions.cmdline = {
              picker.layout_config = {
                width = 100;
                height = 50;
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

            extensions.fzf = {
              fuzzy = true;
              override_generic_sorter = true;
              override_file_sorter = true;
              case_mode = "smart_case";
            };
          };

          after = /* lua */ ''
            local builtin = require("telescope.builtin")

            require('telescope').load_extension('fzf')

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
