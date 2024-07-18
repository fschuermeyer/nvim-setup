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

-- Go (vim-go)
map("n", "<leader>tg", ":GoTestFunc<cr>", { desc = "Testing Golang Function 🐰", silent = true, noremap = true })

-- Enable Copilot
map("n", "<leader>ce", ":Copilot enable<cr>", { desc = "Enable Copilot" })
map("n", "<leader>cx", ":Copilot disable<cr>", { desc = "Disable Copilot" })

-- Tmux Navigator
map("n", "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left", silent = true, noremap = true })
map("n", "<C-j>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down", silent = true, noremap = true })
map("n", "<C-k>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up", silent = true, noremap = true })
map("n", "<C-l>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right", silent = true, noremap = true })
