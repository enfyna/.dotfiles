local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Leader>f', builtin.find_files, {})
vim.keymap.set('n', '<Leader>t', builtin.live_grep, {})
