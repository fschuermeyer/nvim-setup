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

-- Highlight for Terraform Files
vim.cmd([[
  autocmd BufRead,BufNewFile *.hcl set filetype=hcl
  autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
  autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
  autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json
]])

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.java",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.xml",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
