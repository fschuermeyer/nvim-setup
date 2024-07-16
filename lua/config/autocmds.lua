-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
  autocmd BufNewFile,BufRead *.tmpl set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gohtml set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gohtmltmpl set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gotexttmpl  set filetype=gotexttmpl
]])

-- Disable Autoformat for Specific Filetypes
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
    end,
  })
end

-- disable Autoformatting for Stylesheets
set_autoformat({ "css", "scss", "sass" }, false)

set_autoformat({ "kotlin" }, false)

set_autoformat({ "gohtml", "gohtmltmpl", "tmpl" }, false)
