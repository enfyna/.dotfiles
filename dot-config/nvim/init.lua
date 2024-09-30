require("custom.config")

local plugins = require("custom.plugins")

require("lazy").setup({
    plugins,
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
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                { 'L3MON4D3/LuaSnip' },
                { 'onsails/lspkind.nvim' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-buffer' },
            },
            config = function()
                local lspkind = require('lspkind')

                -- Here is where you configure the autocompletion settings.
                local lsp_zero = require('lsp-zero')
                lsp_zero.extend_cmp()

                -- And you can configure cmp even more, if you want to.
                local cmp = require('cmp')
                local cmp_action = lsp_zero.cmp_action()

                local ls = require('luasnip')
                vim.keymap.set({ 'i', 's' }, '<C-k>', function()
                    if ls.expand_or_jumpable() then
                        ls.expand_or_jump()
                    end
                end, { silent = true })

                vim.keymap.set({ 'i', 's' }, '<C-j>', function()
                    if ls.jumpable(-1) then
                        ls.jump(-1)
                    end
                end, { silent = true })

                cmp.setup({
                    formatting = {
                        format = lspkind.cmp_format {
                            mode = 'symbol',
                            maxwidth = 17,
                            ellipsis_char = '...',
                            menu = ({
                                buffer = "󰦪",
                                nvim_lsp = "󰒍",
                            })
                        }
                    },
                    sources = {
                        { name = "nvim_lsp" },
                        { name = "path" },
                        { name = "buffer" },
                    },
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body)
                        end,
                    },
                    mapping = {
                        ["<C-m>"] = cmp.mapping(
                            cmp.mapping.confirm {
                                select = true,
                                cmp.ConfirmBehavior.Insert,
                            },
                            { 'i', 'c' }
                        ),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-x>'] = cmp.mapping.abort(),
                        ['<C-n>'] = cmp.mapping.select_next_item { cmp.ConfirmBehavior.Insert },
                        ['<C-p>'] = cmp.mapping.select_prev_item { cmp.ConfirmBehavior.Insert },
                        ['<C-d>'] = cmp.mapping.scroll_docs(5),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                    },
                })
            end
        },
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

                require('lspconfig').dartls.setup({})

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
