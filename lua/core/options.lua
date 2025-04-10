local opt = vim.opt

-- Nvim Options
-- Tab settings
opt.tabstop = 4
opt.shiftwidth = 4
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true -- Use spaces instead of tabs

-- Line Configs
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false

opt.termguicolors = true
opt.mouse = ""
opt.clipboard = "unnamedplus" -- System Clipboard

-- Persitent Undo History
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.undolevels = 10000

opt.splitright = true
opt.splitbelow = true

opt.confirm = true

-- Fold Settings
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'core.foldexpr'.foldexpr()"
opt.foldtext = ""

if vim.fn.executable("rg") then
    opt.grepprg =
    "rg --vimgrep --no-heading --smart-case --glob '!**/*.min.*' --glob '!**/node_modules/**' --glob '!**/.git/**' --glob '!**/*.lock'"
end

vim.diagnostic.config({ virtual_text = true })
