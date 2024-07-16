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
local disable_autoformat = function(pattern)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = false
    end,
  })
end

-- disable Autoformatting for Stylesheets
disable_autoformat({ "css", "scss", "sass" })

disable_autoformat({ "kotlin" })

disable_autoformat({ "gohtml", "gohtmltmpl", "tmpl" })
