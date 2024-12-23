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

github.com/fschuermeyer/nvim-setup
]]

return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		dashboard = {
			preset = {
				header = logo,
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{
					icon = " ",
					title = "Recent Files",
					cwd = true,
					section = "recent_files",
					indent = 2,
					padding = 1,
				},
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
				{ section = "startup" },
			},
		},
		indent = {
			enabled = true,
			animate = {
				duration = {
					step = 5,
					total = 250,
				},
			},
		},
		scope = { enabled = true },
		scroll = { enabled = true },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#FFA500" }) -- Orange Farbe

		Snacks.toggle.option("wrap", { name = "Line Wrap" }):map("<leader>uw")
		Snacks.toggle.option("number", { name = "Line Numbers" }):map("<leader>un")
		Snacks.toggle.option("relativenumber", { name = "Relative Line Numbers" }):map("<leader>ur")
		Snacks.toggle.option("cursorline", { name = "Cursorline" }):map("<leader>uc")
	end,
}
