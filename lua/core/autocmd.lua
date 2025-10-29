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

-- Consolidate template file type detection
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.tmpl", "*.gohtml", "*.gohtmltmpl" },
    callback = function()
        vim.bo.filetype = "gohtmltmpl"
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.gotexttmpl",
    callback = function()
        vim.bo.filetype = "gotexttmpl"
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.twig",
    callback = function()
        vim.bo.filetype = "html"
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.zsh",
    callback = function()
        vim.bo.filetype = "bash"
    end,
})

-- Consolidate Terraform file type detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.hcl", ".terraformrc", "terraform.rc" },
    callback = function()
        vim.bo.filetype = "hcl"
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.tf", "*.tfvars" },
    callback = function()
        vim.bo.filetype = "terraform"
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.tfstate", "*.tfstate.backup" },
    callback = function()
        vim.bo.filetype = "json"
    end,
})

-- Format Java and XML files on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.java", "*.xml" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
