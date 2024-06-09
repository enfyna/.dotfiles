require("custom")

vim.g.python3_host_prog = "/home/oem/.pyenv/versions/neovim/bin/python"

require("lazy").setup({
    {
        'theprimeagen/harpoon'
    },
    {
        'tpope/vim-fugitive'
    },
    {
        'm4xshen/autoclose.nvim',
        config = function ()
            require('autoclose').setup({
                options = {
                    disable_when_touch = true,
                    pair_spaces = true,
                }
            })
        end
    },
    {
        'windwp/nvim-ts-autotag',
        config = function()
            require('nvim-ts-autotag').setup({})
        end
    },
    {
        "okuuva/auto-save.nvim",
        cmd = "ASToggle",                         -- optional for lazy loading on command
        event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
        opts = {
            -- your config goes here
            -- or just leave it empty :)
        },
    },
    {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup({
                render = "background", -- background | foreground | virtual
                enable_tailwind = true,
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                auto_install = true,
                highlight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader>ss",
                        node_incremental = "<Leader>si",
                        node_decremental = "<Leader>sd",
                        scope_incremental = "<Leader>sc",
                    },
                },
            })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({
                defaults = {
                    layout_config = {
                        horizontal = {
                            preview_cutoff = 0,
                            preview_width = 0.5,
                        },
                    },
                },
            })
        end
    },
    {
        'linux-cultist/venv-selector.nvim',
        branch = 'regexp',
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
        event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        opts = {},
        keys = {},
        config = function ()
            require('venv-selector').setup({})
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                sections = {
                    lualine_x = {
                        {
                            'fileformat',
                        },
                        --{
                        --    'encoding',
                        --},
                        --{
                        --    'searchcount',
                        --}
                    },
                    lualine_z = {
                        {
                            'filetype',
                            colored = false,
                            icon_only = true,
                        },
                    }
                }
            })
        end
    },
    {
        'projekt0n/github-nvim-theme',
        --        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        --        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                options = {
                    dim_inactive = true,
                    transparent = true,
                    styles = {
                        constants = 'bold',
                        comments = 'italic',
                        --keywords = 'bold',
                        --types = 'italic,bold',
                    }
                }
            })
            vim.cmd('colorscheme github_dark_default')
        end,
    },
    {

        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
            lazy = true,
            config = false,
            init = function()
                -- Disable automatic setup, we are doing it manually
                vim.g.lsp_zero_extend_cmp = 0
                vim.g.lsp_zero_extend_lspconfig = 0
            end,
        },
        {
            'williamboman/mason.nvim',
            lazy = false,
            config = true,
        },

        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                { 'L3MON4D3/LuaSnip' },
            },
            config = function()
                -- Here is where you configure the autocompletion settings.
                local lsp_zero = require('lsp-zero')
                lsp_zero.extend_cmp()

                -- And you can configure cmp even more, if you want to.
                local cmp = require('cmp')
                local cmp_action = lsp_zero.cmp_action()

                cmp.setup({
                    formatting = lsp_zero.cmp_format(),
                    mapping = cmp.mapping.preset.insert({
                        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-d>'] = cmp.mapping.scroll_docs(5),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                    })
                })
            end
        },

        -- LSP
        {
            'neovim/nvim-lspconfig',
            cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
            event = { 'BufReadPre', 'BufNewFile' },
            dependencies = {
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'williamboman/mason-lspconfig.nvim' },
            },
            config = function()
                -- This is where all the LSP shenanigans will live
                local lsp_zero = require('lsp-zero')
                lsp_zero.extend_lspconfig()

                lsp_zero.configure('gdscript', {
                    force_setup = true, -- because the LSP is global. Read more on lsp-zero docs about this.
                    single_file_support = false,
                    root_dir = require('lspconfig.util').root_pattern('project.godot', '.git'),
                    filetypes = { 'gd', 'gdscript', 'gdscript3' }
                })

                --- if you want to know more about lsp-zero and mason.nvim
                --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
                lsp_zero.on_attach(function(client, bufnr)
                    -- see :help lsp-zero-keybindings
                    -- to learn the available actions
                    lsp_zero.default_keymaps({ buffer = bufnr })
                end)

                require('mason-lspconfig').setup({
                    ensure_installed = {},
                    handlers = {
                        lsp_zero.default_setup,
                        lua_ls = function()
                            -- (Optional) Configure lua language server for neovim
                            local lua_opts = lsp_zero.nvim_lua_ls()
                            require('lspconfig').lua_ls.setup(lua_opts)
                        end,
                    }
                })
            end
        }

    },
})
