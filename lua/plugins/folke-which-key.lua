return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
        preset = "helix",
        sort = {"alphanum"},
		spec = {
			mode = { "n", "v" },
			{ "<leader>d", group = "debug" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>g", group = "git" },
			{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
		},
	},
}
