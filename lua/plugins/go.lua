-- Go Plugins

return {
  {
    "fatih/vim-go",
    run = ":GoUpdateBinaries",
    config = function()
      -- vim-go Einstellungen hier
      vim.g.go_def_mode = "gopls"
      vim.g.go_info_mode = "gopls"
      vim.g.go_fmt_command = "goimports"
      vim.g.go_auto_type_info = 1
    end,
  },
}
