return {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("tokyonight").setup({
            transparent = true,
            style = "night",
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            on_highlights = function(hl, _)
                hl.Comment = { fg = "#9aa5ce", italic = true }
            end,
        })
        vim.cmd("colorscheme tokyonight")
    end,
}
