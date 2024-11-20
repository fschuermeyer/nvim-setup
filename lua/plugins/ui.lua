local logo = [[
`8.`888b           ,8'  8 8888          ,8.       ,8.          
 `8.`888b         ,8'   8 8888         ,888.     ,888.         
  `8.`888b       ,8'    8 8888        .`8888.   .`8888.        
   `8.`888b     ,8'     8 8888       ,8.`8888. ,8.`8888.       
    `8.`888b   ,8'      8 8888      ,8'8.`8888,8^8.`8888.      
     `8.`888b ,8'       8 8888     ,8' `8.`8888' `8.`8888.     
      `8.`888b8'        8 8888    ,8'   `8.`88'   `8.`8888.    
       `8.`888'         8 8888   ,8'     `8.`'     `8.`8888.   
        `8.`8'          8 8888  ,8'       `8        `8.`8888.  
         `8.`           8 8888 ,8'         `         `8.`8888. 
]]

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
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = logo,
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", cwd = true, section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
          { section = "startup" },
        },
      },
    },
  },
}
