return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        sort = { "alphanum" },
        spec = {
            mode = { "n", "v" },
            { "<leader>m", group = "message", icon = { icon = " ", color = "blue" } },
            { "<leader>e", icon = { icon = " ", color = "yellow" } },
            { "<leader>t", icon = { icon = "󰙨 ", color = "green" }, group = "test" },
            { "<leader>b", group = "buffer", icon = { icon = " ", color = "yellow" } },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        },
    },
}
