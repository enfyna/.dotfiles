return {
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
}
