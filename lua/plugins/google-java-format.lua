return {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
        local nls = require("null-ls")

        opts.sources = vim.tbl_extend("force", opts.sources or {}, {
            nls.builtins.formatting.google_java_format.with({
                extra_args = { "--aosp" }, -- Optional, kann weggelassen werden
            }),
        })
    end,
}
