return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
        local promptLanguage = {
            go = true,
            java = true,
        }

        require("refactoring").setup({
            prompt_func_return_type = promptLanguage,
            prompt_func_param_type = promptLanguage,
        })
    end,
}
