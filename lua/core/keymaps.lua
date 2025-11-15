vim.g.mapleader = " "

local setKey = vim.keymap.set
local delKey = vim.keymap.del

-- Move Lines
local moveUp = { noremap = true, silent = true, desc = "Move the Line Up" }
local moveDown = { noremap = true, silent = true, desc = "Move the Line Down" }
local keyMapUp = "<C-n>"
local keyMapDown = "<C-b>"

setKey("n", keyMapUp, "<cmd>m .-2<cr>==", moveUp)
setKey("n", keyMapDown, "<cmd>m .+1<cr>==", moveDown)

setKey("i", keyMapUp, "<esc><cmd>m .-2<cr>==gi", moveUp)
setKey("i", keyMapDown, "<esc><cmd>m .+1<cr>==gi", moveDown)

setKey("v", keyMapUp, ":m '<-2<cr>gv=gv", moveUp)
setKey("v", keyMapDown, ":m '>+1<cr>gv=gv", moveDown)

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

-- Center after Scroll
setKey("n", "<C-d>", "<C-d>zz<CR>", { desc = "Center after Scroll" })
setKey("n", "<C-u>", "<C-u>zz<CR>", { desc = "Center after Scroll" })

setKey("n", "<leader>us", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlights" })

-- Disable Copilot
setKey("n", "<leader>ay", "<cmd>Copilot disable<CR>", { desc = "Copilot Disable" })
setKey("n", "<leader>aY", "<cmd>Copilot enable<CR>", { desc = "Copilot Enable" })

-- Next/Prev Diagnostic
setKey("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next Diagnostic" })
setKey("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev Diagnostic" })

-- Disable (slows down reference keymap)
delKey("n", "gri")
delKey("n", "gra")
delKey("n", "grt")
delKey("n", "grr")
delKey("n", "grn")
