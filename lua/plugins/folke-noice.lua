return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("noice").setup({
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
        })

        local setKey = vim.keymap.set

        setKey("n", "<leader>mx", "<cmd>Noice dismiss<CR>", { noremap = true, silent = true, desc = "Dismiss Messages" })
        setKey("n", "<leader>ml", "<cmd>Noice last<CR>", { noremap = true, silent = true, desc = "Last Message" })
        setKey("n", "<leader>mh", "<cmd>Noice telescope<CR>", { noremap = true, silent = true, desc = "History" })
    end,
}
