local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>r', builtin.git_files, {})
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>t', builtin.live_grep, {})
