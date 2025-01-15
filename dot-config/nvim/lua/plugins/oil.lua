return {
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
    end
}
