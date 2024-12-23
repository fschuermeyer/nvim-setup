return {
	"LunarVim/bigfile.nvim",
	event = "BufReadPre",
	opts = {
		filesize = 3,
	},
	config = function(_, opts)
		require("bigfile").setup(opts)
	end,
}
