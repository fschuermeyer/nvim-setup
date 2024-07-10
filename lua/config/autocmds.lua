-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
  autocmd BufNewFile,BufRead *.tmpl set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gohtml set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gohtmltmpl set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gotexttmpl  set filetype=gotexttmpl
]])
