return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local neo_tree = require("neo-tree")

        neo_tree.setup({
            window = {
                mappings = {
                    -- fix: german layout
                    ["<"] = "next_source",
                    [">"] = "prev_source",
                    ["l"] = "open",
                    ["h"] = "close_node",
                },
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                },
            },
            source_selector = {
                winbar = true,
            },
        })

        local setKey = vim.keymap.set

        setKey(
            "n",
            "<leader>e",
            "<cmd>Neotree float toggle<cr>",
            { noremap = true, silent = true, desc = "Explorer NeoTree" }
        )
    end,
}
