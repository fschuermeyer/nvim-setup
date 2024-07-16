return {
  { "fredrikaverpil/neotest-golang", enabled = false },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      local goAdapter = require("neotest-go")({
        args = { "-v" },
      })

      local pyAdapter = require("neotest-python")({
        args = { "-s", "-vv" },
        runner = "pytest",
      })

      local jestAdapter = require("neotest-jest")({
        jestConfigFile = "jest.config.js",
        jestCommand = "yarn jest",
      })

      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = { goAdapter, pyAdapter, jestAdapter },
        ---@diagnostic disable-next-line: missing-fields
        diagnostic = {
          enable = true,
        },
      })
    end,
  },
}
