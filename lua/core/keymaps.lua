vim.g.mapleader = " "

local setKey = vim.keymap.set

setKey("n", "<leader>q", ":q<CR>", { desc = "Exit Nvim" })

-- Move Lines
-- setKey("n", "<C-m>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
-- setKey("n", "<C-n>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
-- setKey("i", "<C-n>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- setKey("i", "<C-m>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
-- setKey("v", "<C-n>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
-- setKey("v", "<C-m>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Diffview
setKey("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview Current File" })
setKey("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview History" })
setKey("n", "<leader>gt", "<cmd>DiffviewClose<cr>", { desc = "Diffview Close" })
setKey("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
setKey("n", "<leader>gp", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", { desc = "Diffview Branch" })

-- Window Mappings
setKey("n", "<leader>#", "<cmd>vsplit<cr>", { desc = "Split Window Vertically" })
setKey("n", "<leader>-", "<cmd>split<cr>", { desc = "Split Window Horizontally" })

-- AlternateToggler
setKey("n", "<leader>i", "<cmd>ToggleAlternate<CR>", { desc = "Toggle State" })

-- VimGo
setKey("n", "<leader>tg", "<cmd>GoTestFunc<CR>", { desc = "Test Golang" })
