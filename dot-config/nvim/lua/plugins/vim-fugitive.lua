return {
    'tpope/vim-fugitive',
    lazy = false,
    keys = {
        { '<leader>gg', function() vim.cmd('vert Git') end, desc = 'git fugitive' },
        { '<leader>gf', ':Gvdiffsplit ',                    desc = 'git diff split' }
    }
}
