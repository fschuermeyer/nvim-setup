-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local enableKey = vim.keymap.set

-- Move Lines
-- Alternative Commands for MacOS "option/alt" Key not working
enableKey("n", "<C-m>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
enableKey("n", "<C-n>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
enableKey("i", "<C-n>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
enableKey("i", "<C-m>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
enableKey("v", "<C-n>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
enableKey("v", "<C-m>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Go (vim-go)
enableKey(
  "n",
  "<leader>tg",
  ":GoTestFunc<cr>",
  { desc = "Testing Golang Function 🐰", silent = true, noremap = true }
)

-- Enable Copilot
enableKey("n", "<leader>ce", ":Copilot enable<cr>", { desc = "Enable Copilot" })
enableKey("n", "<leader>cx", ":Copilot disable<cr>", { desc = "Disable Copilot" })

-- Tmux Fix move CTRL+A to CTRL+Q
enableKey("n", "<C-q>", "<C-a>", { desc = "Increment Numbers", silent = true, noremap = true })

-- Tmux Navigator
enableKey("n", "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left", silent = true, noremap = true })
enableKey("n", "<C-j>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down", silent = true, noremap = true })
enableKey("n", "<C-k>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up", silent = true, noremap = true })
enableKey("n", "<C-l>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right", silent = true, noremap = true })

-- Diffview Keymaps

enableKey("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview Current File" })
enableKey("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview History" })
enableKey("n", "<leader>gt", "<cmd>DiffviewClose<cr>", { desc = "Diffview Close" })
enableKey("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
enableKey("n", "<leader>gp", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", { desc = "Diffview Branch" })

-- Alternate Toggler
enableKey(
  "n",
  "<leader>i",
  "<cmd>lua require('alternate-toggler').toggleAlternate()<cr>",
  { desc = "Toggle Alternate" }
)
