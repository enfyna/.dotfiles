return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
        require('telescope').setup({
            defaults = {
                layout_config = {
                    horizontal = {
                        preview_cutoff = 1,
                        preview_width = 0.5,
                    },
                },
            },
            pickers = {
                find_files = {
                    theme = "ivy",
                }
            },
            extensions = {
                fzf = {}
            }
        })
        require('telescope').load_extension('fzf')

        vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags)

    end
}
