return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "S", false, mode = { "v", "n", "x" } },
      { "s", false, mode = { "v", "n", "x" } },
      {
        "ü",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "Ü",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
