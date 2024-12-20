return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"BurntSushi/ripgrep",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local layout = require("telescope.actions.layout")
		local todo = require("todo-comments")

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-p>"] = layout.toggle_preview, -- toggle preview
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set(
			"n",
			"<leader><space>",
			"<cmd>Telescope find_files sort_mru=true<cr>",
			{ desc = "Find Files (Root Dir)" }
		)
		keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
		keymap.set(
			"n",
			"<leader>fb",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
			{ desc = "Buffers" }
		)

		keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find Grep" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find Recent" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })

		-- git
		keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
		keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
		keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches" })
	end,
}
