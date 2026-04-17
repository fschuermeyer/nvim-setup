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
                    "--config=" .. os.getenv("HOME") .. "/.config/nvim/lua/plugins/rules/sqlfluff.cfg",
                    "--dialect=postgres",
                    "--processes=1",
                    "--format=json",
                    "-",
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

        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                for _, procs in pairs(lint.get_running()) do
                    for _, proc in ipairs(procs) do
                        if proc and not proc:is_closing() then
                            proc:kill(9)
                        end
                    end
                end
            end,
        })
    end,
}
