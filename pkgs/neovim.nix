{ config, pkgs, nvf, home-manager,  ... }: 
let 
    hl = "vim.api.nvim_set_hl";
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

                foldmethod = "expr";
                foldexpr = "nvim_treesitter#expr()";
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
                    };

                    after = /* lua */ ''
                        vim.cmd("Catppuccin macchiato")

                        ${hl}(0, "Normal", { bg = "none" })  
                        ${hl}(0, "TelescopeNormal", {bg = "none" })
                        ${hl}(0, "TelescopeBorder", {bg = "none", fg = "#6F7295" })

                        ${hl}(0, "TelescopePromptNormal", { bg = "none" })
                        ${hl}(0, "TelescopePromptBorder", { bg = "none", fg = "#6F7295" })
                        ${hl}(0, "TelescopePromptTitle", { bg = "none", fg = "#6F7295" })
                        ${hl}(0, "TelescopeResultsNormal", { bg = "none" })
                        ${hl}(0, "TelescopeResultsBorder", { bg = "none", fg = "#6F7295" })
                        ${hl}(0, "TelescopePreviewNormal", { bg = "none" })
                        ${hl}(0, "TelescopePreviewBorder", { bg = "none", fg = "#6F7295" }) 

                        ${hl}(0, "CursorLineNr", {
                            fg = "#fab387",
                            bold = true,
                        })
                    '';
                };

                "plenary.nvim" = {
                    package = pkgs.vimPlugins.plenary-nvim;
                    lazy = false;
                    priority = 1001;
                };

                "overseer.nvim" = {
                    package = pkgs.vimPlugins.overseer-nvim;
                    priority = 1001;

                    after = /* lua */ ''
                        overseer = require('overseer')

                        overseer.register_template({
                            name = "Compile Release",
                            builder = function(params) 
                                return {
                                    cmd = { "make"},
                                    args = { "-j2" },
                                }
                            end,

                            desc = "Compile the project",
                            tags = {overseer.TAG.BUILD},
                        })                       
                    
                    '';
                };

                
                "telescope.nvim" = {
                    package = pkgs.vimPlugins.telescope-nvim;
                    lazy = false;
                    priority = 1000;
                    setupModule = "telescope";

                    setupOpts = {
                        exntentions.cmdline = {
                            picker.layout_config = { width = 120; height = 25; };
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
