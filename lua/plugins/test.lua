local function get_javascript_adapter_test()
  if vim.fn.findfile("jest.config.js", ".;") ~= "" or vim.fn.findfile("jest.config.ts", ".;") ~= "" then
    return require("neotest-jest")({
      jestConfigFile = "jest.config.js",
      jestCommand = "yarn jest",
    })
  end

  if vim.fn.findfile("vite.config.js", ".;") ~= "" or vim.fn.findfile("vite.config.ts", ".;") ~= "" then
    return require("neotest-vitest")({
      is_test_file = function(file_path)
        if string.match(file_path, "test.ts") then
          return true
        end
      end,
    })
  end

  return nil
end

return {
  { "fredrikaverpil/neotest-golang", enabled = false },
  { "mrcjkb/neotest-haskell", enabled = false },
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
      "marilari88/neotest-vitest",
    },
    config = function()
      local goAdapter = require("neotest-go")({
        args = { "-v" },
      })

      local pyAdapter = require("neotest-python")({
        args = { "-s", "-vv" },
        runner = "pytest",
      })

      local jsAdapter = get_javascript_adapter_test()

      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = { goAdapter, pyAdapter, jsAdapter },
        ---@diagnostic disable-next-line: missing-fields
        diagnostic = {
          enable = true,
        },
      })
    end,
  },
}
