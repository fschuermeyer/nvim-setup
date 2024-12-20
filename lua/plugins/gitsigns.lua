return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 400,
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function setMap(mode, key, action, desc)
				vim.keymap.set(mode, key, action, { buffer = buffer, desc = desc })
			end

            -- git
			setMap("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Git Blame")

            -- ui
			setMap("n", "<leader>ub", "<cmd>:Gitsigns toggle_current_line_blame<CR>", "Toggle Current Line Git Blame")

			Snacks.toggle({
				name = "Git Signs",
				get = function()
					return require("gitsigns.config").config.signcolumn
				end,
				set = function(state)
					require("gitsigns").toggle_signs(state)
				end,
			}):map("<leader>ug")
		end,
	},
}
