return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")

        local utils = require("core.utils")

        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
                "json",
                "angular",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "markdown",
                "markdown_inline",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "go",
                "php",
                "csv",
                "dart",
                "diff",
                "editorconfig",
                "gomod",
                "gosum",
                "gotmpl",
                "haskell",
                "java",
                "jq",
                "kotlin",
                "python",
                "sql",
                "tmux",
                "vue",
                "xml",
                "regex",
                "terraform",
                "hcl",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            -- some default options
            sync_install = true,
            ignore_install = {},
            auto_install = false,
        })

        -- Highlight html as Angular if angular.json exists
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
            pattern = "*.html",
            callback = function()
                if utils.is_angular_project() then
                    vim.bo.filetype = "htmlangular"
                end
            end,
        })
    end,
}
