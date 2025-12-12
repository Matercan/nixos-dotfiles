{ pkgs, telescope-cmdline-nvim, ... }: 
let 
    hl = "vim.api.nvim_set_hl";

    cmdline-from-source = pkgs.vimUtils.buildVimPlugin {
        name = "telescope-cmdline-nvim";
        src = telescope-cmdline-nvim;
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
            vim.lsp.enable = true;
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
                tabstop = 4;
                shiftwidth = 4;
                softtabstop = 4;

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
                ];

                highlight.enable = true;
                indent.enable = true;
                fold = true;
            };

            vim.luaConfigRC.replace = /* lua */ ''
                vim.keymap.set('n', '<leader>rh', function()
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

            vim.languages = {
                nix.enable = true;
                rust.enable = true;
                clang.enable = true;
                bash.enable = true;
                csharp.enable = true;
            };

            vim.keymaps = [
                {
                    key = "<leader>e";
                    mode = ["n"];
                    action = ":wq<CR>";
                    desc = "Save and quit a file";
                }
                {
                    key = "<leader>s";
                    mode = ["n"];
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
                        ${hl}(0, "TelescopeNormal", {bg = "none" })
                        ${hl}(0, "TelescopeBorder", {bg = "none", fg = macchiato.blue })

                        ${hl}(0, "TelescopePromptNormal", { bg = "none" })
                        ${hl}(0, "TelescopePromptBorder", { bg = "none", fg = macchiato.blue })
                        ${hl}(0, "TelescopePromptTitle", { bg = "none", fg = macchiato.blue })
                        ${hl}(0, "TelescopeResultsNormal", { bg = "none" })
                        ${hl}(0, "TelescopeResultsBorder", { bg = "none", fg = macchiato.blue })
                        ${hl}(0, "TelescopePreviewNormal", { bg = "none" })
                        ${hl}(0, "TelescopePreviewBorder", { bg = "none", fg = macchiato.blue }) 


                        ${hl}(0, "CursorLineNr", {
                            fg = macchiato.peach,
                            bold = true,
                        })
                    '';
                };

                "plenary.nvim" = (dependsPlugin // { package = pkgs.vimPlugins.plenary-nvim;} );
                "overseer.nvim" = (dependsPlugin // { package = pkgs.vimPlugins.overseer-nvim; });
                "nvim-web-devicons" = (dependsPlugin // { package = pkgs.vimPlugins.nvim-web-devicons; });
                "mini.icons" = (dependsPlugin // { package = pkgs.vimPlugins.mini-icons; });

                "indent-blankline.nvim" = {
                    package = pkgs.vimPlugins.indent-blankline-nvim;
                    setupModule = "ibl";
                };

                "dashboard-nvim" = {
                    package = pkgs.vimPlugins.dashboard-nvim;
                    setupModule = "dashboard";
                };

                "oil.nvim" = {
                    package = pkgs.vimPlugins.oil-nvim;
                    setupModule = "oil";
                };

                "vim-fugitive".package = pkgs.vimPlugins.vim-fugitive;
                "gitsigns.nvim".package = pkgs.vimPlugins.gitsigns-nvim; 

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
                            picker.layout_config = { width = 240; height = 100; };
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

                        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
                        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
                        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
                        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

                        vim.api.nvim_set_keymap('n', 'Q', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
                        vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
                    '';
                };
            };
        };
    };
}
