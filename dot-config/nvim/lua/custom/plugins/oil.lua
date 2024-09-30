return {
    'stevearc/oil.nvim',
    config = function()
        require('oil').setup({
            win_options = {
                signcolumn = "yes:2",
            },
            view_options = {
                show_hidden = true,
            }
        })
    end
}
