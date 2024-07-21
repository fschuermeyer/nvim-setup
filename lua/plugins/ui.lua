-- define the colorscheme for nvim
return {
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufEnter",
    opts = { "*" },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      style = "night",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {},
      },
    },
  },
}
