return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function()
    local neo_tree = require("neo-tree")

    neo_tree.setup({
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
      source_selector = {
        winbar = true,
      },
    })
  end,
}
