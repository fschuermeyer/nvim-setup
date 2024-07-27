return {
  "christoomey/vim-tmux-navigator",
  "ThePrimeagen/vim-be-good",
  "sindrets/diffview.nvim",
  "rmagatti/alternate-toggler",
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {
      filesize = 3,
    },
    config = function(_, opts)
      require("bigfile").setup(opts)
    end,
  },
}
