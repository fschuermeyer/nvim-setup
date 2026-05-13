return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	keys = {
		{ "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
		{
			"<leader>rs",
			function()
				local connections = vim.fn["db_ui#connections_list"]()
				if vim.tbl_isempty(connections) then
					vim.notify("No dadbod connections found. Add one via :DBUIAddConnection", vim.log.levels.WARN)
					return
				end

				vim.ui.select(connections, {
					prompt = "Select connection:",
					format_item = function(conn)
						return conn.name .. " [" .. conn.source .. "]"
					end,
				}, function(conn)
					if not conn then
						return
					end
					vim.b.db = conn.url
					vim.cmd("%DB")
				end)
			end,
			desc = "Run SQL",
			ft = { "sql", "mysql", "plsql" },
		},
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		local data_path = vim.fn.stdpath("data")

		local function update_db_paths()
			local sql_dir = vim.fn.getcwd() .. "/sql"
			if vim.fn.isdirectory(sql_dir) == 1 then
				vim.g.db_ui_save_location = sql_dir
				vim.g.db_ui_tmp_query_location = sql_dir .. "/tmp"
			else
				vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
				vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
			end
		end

		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_show_database_icon = true
		vim.g.db_ui_use_nerd_fonts = true
		vim.g.db_ui_use_nvim_notify = true
		vim.g.db_ui_execute_on_save = false

		update_db_paths()

		vim.api.nvim_create_autocmd("DirChanged", {
			group = vim.api.nvim_create_augroup("dadbod_paths", { clear = true }),
			callback = update_db_paths,
		})
	end,
}
