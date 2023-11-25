vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- quickfix maps
-- navigate quickfix list 
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[q", ":cprev<CR>")
