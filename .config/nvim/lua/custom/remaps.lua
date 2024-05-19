vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>", vim.cmd.Ex)
-- vim.keymap.set("n", "<Leader>as", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
-- vim.api.nvim_set_keymap('n', '<space>se', ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>', {noremap = true, silent = true})

-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv'")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv'")

-- vim.keymap.set("n", "<Leader>ca", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
