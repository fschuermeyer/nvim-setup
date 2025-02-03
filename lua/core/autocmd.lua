vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#C11B3B", fg = "#F3A3B3" })

-- Highlight, was gejankt wurde
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "YankHighlight",
            timeout = 200,
        })
    end,
})

-- Highlight for Template Files
vim.cmd([[
  autocmd BufNewFile,BufRead *.tmpl set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gohtml set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gohtmltmpl set filetype=gohtmltmpl
  autocmd BufNewFile,BufRead *.gotexttmpl  set filetype=gotexttmpl
  autocmd BufNewFile,BufRead *.twig set filetype=html
  autocmd BufNewFile,BufRead *.zsh set filetype=bash
]])
