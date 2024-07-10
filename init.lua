-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- provider setup
vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/3.11.0/bin/python3"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
