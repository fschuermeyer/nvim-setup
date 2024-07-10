-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
return {
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-golang"] = {
          go_test_args = { "-v", "-race", "-count=1" },
          dep_go_enabled = true,
        },
        ["neotest-jest"] = {
          jestCommand = "yarn run unit-tests",
          jestConfigFile = "jest.config.js",
        },
      },
    },
  },
}
