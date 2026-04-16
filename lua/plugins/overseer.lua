return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen", "OverseerClose" },
    keys = {
      { "<leader>co", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
      { "<leader>ct", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
    },
    config = function()
      require("overseer").setup({
        task_list = {
          direction = "bottom",
          default_detail = 1,
        },
      })
    end,
  },
}
