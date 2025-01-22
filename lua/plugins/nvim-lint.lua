return {
    "mfussenegger/nvim-lint",
    opts = {
        events = { "BufWritePost", "BufReadPost", "InsertLeave", "FileReadPost" },
        linters_by_ft = {
            sql = { "sqlfluff" },
        },
        linters = {
            sqlfluff = {
                args = {
                    "lint",
                    "--config=" .. os.getenv("HOME") .. "/.config/nvim/lua/plugins/sqlfluff.cfg",
                    "--dialect=postgres",
                    "--format=json",
                },
            },
        },
    },
    config = function(_, opts)
        local lint = require("lint")
        lint.linters_by_ft = opts.linters_by_ft
        lint.linters.sqlfluff.args = opts.linters.sqlfluff.args

        vim.api.nvim_create_autocmd(opts.events, {
            callback = function()
                if vim.bo.filetype == "sql" then
                    lint.try_lint("sqlfluff")
                else
                    lint.try_lint()
                end
            end
        })
    end,
}
