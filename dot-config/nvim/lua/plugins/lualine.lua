return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                component_seperators = { left = '•', right = '•'},
                section_separators = { left = '•', right = '•'},
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
}
