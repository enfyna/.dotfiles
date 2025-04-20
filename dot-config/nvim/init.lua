local lazy = require("bootstrap_lazy")

vim.g.mapleader = " "

lazy.setup({
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
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            local luasnip = require('luasnip')

            luasnip.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format {
                        mode = 'symbol',
                        maxwidth = 17,
                        ellipsis_char = '...',
                        menu = ({
                            path = "/",
                            buffer = "󰦪",
                            nvim_lsp = "󰒍",
                        })
                    }
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
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
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
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
            require("mason-lspconfig").setup()
            require('lspconfig').clangd.setup({ -- dont install clangd from mason
                cmd = { 
                    "clangd",
                    "--fallback-style=webkit",
                }
            })
            require("mason-lspconfig").setup_handlers {
                -- :h mason-lspconfig-automatic-server-setup
                function (server_name)
                    require("lspconfig")[server_name].setup {}
                end,
            }
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                auto_install = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup({
                columns = {
                    "icon",
                    "size",
                },
                win_options = {
                    signcolumn = "yes:2",
                },
                view_options = {
                    show_hidden = true,
                }
            })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    layout_strategy = "vertical",
                    border = false,
                    layout_config = {
                        preview_height = 0.6,
                        preview_cutoff = 0,
                        height = function(_, max_lines)
                            return math.floor(max_lines)
                        end,
                        width = function(_, max_lines)
                            return math.floor(max_lines)
                        end,
                    },
                },
                extensions = {
                    fzf = {}
                },
            })
            telescope.load_extension('fzf')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local custom_theme = require('lualine.themes.16color')
            custom_theme.insert = { 
                a = { fg = '#ffffff', bg = '#005500' }, 
            }
            require('lualine').setup({
                options = {
                    theme = custom_theme,
                    component_seperators = { left = ' ', right = '█'},
                    section_separators = { left = ' ', right = '█'},
                },
                sections = {
                    lualine_b = { { 'branch' }, },
                    lualine_c = { { 'diff' }, },
                    lualine_x = {
                        { 'diagnostics' },
                        { 'filename', symbols = {
                            modified = '~',
                            readonly = '®',
                            unnamed = '',
                            newfile = '[+]',
                            }
                        },
                    },
                    lualine_y = { { 'progress' }, },
                    lualine_z = {
                        { 'filetype', colored = false, icon_only = true, },
                    }
                }
            })
        end
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
    },
    {
        'okuuva/auto-save.nvim',
        cmd = "ASToggle",
        event = { "InsertLeave", "TextChanged" },
        opts = { }
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function ()
            require('gitsigns').setup()
        end
    },
    {
        "SirZenith/oil-vcs-status",
        dependencies = { "stevearc/oil.nvim", },
        config = true,
    },
    {
        'jake-stewart/multicursor.nvim',
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()
        end
    },
    {
        'theprimeagen/harpoon'
    },
})

-- format before saving
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- opt start
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.colorcolumn = "80"
vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.smartindent = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.termguicolors = false
vim.opt.signcolumn = "yes:2"
vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- opt end


-- remaps start
vim.keymap.set("n", "<Leader> ", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<Leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "<Leader>rr", "<Cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "<Leader>w", "<C-w>w")
vim.keymap.set("n", "gl", "<Cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("i", "<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "<Leader>'", ":norm gcip<CR>")
vim.keymap.set("n", "<Leader>i", ":norm gcc<CR>")
vim.keymap.set("x", "<Leader>i", ":norm gcc<CR>")

local telescope = require('telescope.builtin')

vim.keymap.set("n", "<Leader>fh", telescope.help_tags)
vim.keymap.set("n", "<Leader>ff", telescope.find_files, {})
vim.keymap.set("n", "<Leader>ft", telescope.live_grep, {})

-- vim-fugitive

vim.keymap.set("n", "<Leader>gg", function() vim.cmd('vert Git') end)
vim.keymap.set("n", "<Leader>gf", ":Gvdiffsplit <CR>")

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

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<Leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)

local mc = require("multicursor-nvim")

vim.keymap.set("x", "S", mc.splitCursors)
vim.keymap.set("x", "M", mc.matchCursors)

vim.keymap.set({"n", "x"}, "<c-q>", mc.toggleCursor)

vim.keymap.set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
vim.keymap.set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
vim.keymap.set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
vim.keymap.set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
    layerSet({"n", "x"}, "<C-k>", mc.prevCursor)
    layerSet({"n", "x"}, "<C-j>", mc.nextCursor)

    -- Enable and clear cursors using escape.
    layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
end)

-- remaps end

-- visual stuff start
vim.cmd.colorscheme("vim")

vim.api.nvim_set_hl(0, "NormalFloat", { ctermbg = 0, blend = 0 })
vim.api.nvim_set_hl(0, "FloatBorder", { ctermbg = 0, ctermfg = 2 })
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = 0, ctermfg = 2 })
vim.api.nvim_set_hl(0, "DiffDelete", { ctermbg = 0, ctermfg = 1 })
vim.api.nvim_set_hl(0, "DiffAdd", { ctermbg = 0, ctermfg = 2 })
vim.api.nvim_set_hl(0, "DiffChange", { ctermbg = 0, ctermfg = 3 })

vim.api.nvim_set_hl(0, "number", { ctermbg = 0, ctermfg = 42 })
vim.api.nvim_set_hl(0, "string", { ctermbg = 0, ctermfg = 42 })
vim.api.nvim_set_hl(0, "boolean", { ctermbg = 0, ctermfg = 42 })
vim.api.nvim_set_hl(0, "comment", { ctermbg = 0, ctermfg = 33 })

vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Visual", reverse = true })

vim.o.winborder = 'double'

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.diagnostic.config({
    virtual_text = true,
})
-- visual stuff end

