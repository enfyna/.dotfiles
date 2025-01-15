return {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    event = 'VeryLazy',     -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    opts = {},
    keys = {},
    config = function()
        require('venv-selector').setup({})
    end
}
