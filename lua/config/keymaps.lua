-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Move Lines
-- Alternative Commands for MacOS "option/alt" Key not working
map("n", "<C-m>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("n", "<C-n>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("i", "<C-n>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<C-m>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<C-n>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<C-m>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
