return {
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
}
