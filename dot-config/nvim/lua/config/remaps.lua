vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>w", "<C-w><C-w>")

vim.keymap.set("n", "<Leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>") -- code actions
vim.keymap.set("n", "<Leader>ii", "<Cmd>lua vim.lsp.buf.format({ async = true })<CR>") -- re indent
vim.keymap.set("n", "<Leader>rr", "<Cmd>lua vim.lsp.buf.rename()<CR>") -- rename variable
vim.keymap.set("n", "<Leader>tt", "<C-w><C-v><Cmd>term<CR>i") -- rename variable
vim.keymap.set("i", "<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>") -- signature help in insert mode

vim.keymap.set("n", "<Leader>g", vim.cmd.Git)
vim.keymap.set("n", "<Leader> ", "<CMD>Oil<CR>", { desc = "Open parent directory" })

