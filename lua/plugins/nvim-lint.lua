return {
	"mfussenegger/nvim-lint",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave", "FileReadPost" },
		linters_by_ft = {
			sql = { "sqlfluff" },
			c = { "clangtidy" },
		},
		linters = {
			sqlfluff = {
				args = {
					"lint",
					"--config=" .. os.getenv("HOME") .. "/.config/nvim/lua/plugins/rules/sqlfluff.cfg",
					"--dialect=postgres",
					"--processes=1",
					"--format=json",
					"-",
				},
			},
			clangtidy = {
				args = {
					"--quiet",
					"--checks=-*,clang-analyzer-*",
				},
			},
		},
	},
	config = function(_, opts)
		local lint = require("lint")
		lint.linters_by_ft = opts.linters_by_ft
		lint.linters.sqlfluff.args = opts.linters.sqlfluff.args
		lint.linters.clangtidy.args = opts.linters.clangtidy.args

		local function drop_compiler_errors(linter)
			return require("lint.util").wrap(linter, function(d)
				if (d.code or ""):find("^clang%-diagnostic%-") then
					return nil
				end
				return d
			end)
		end

		lint.linters.clangtidy = drop_compiler_errors(lint.linters.clangtidy)

		vim.api.nvim_create_autocmd(opts.events, {
			callback = function(args)
				if vim.bo.filetype == "sql" then
					lint.try_lint("sqlfluff")
				elseif args.event ~= "InsertLeave" then
					lint.try_lint()
				end
			end,
		})

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				for _, procs in pairs(lint.get_running()) do
					for _, proc in ipairs(procs) do
						if proc and not proc:is_closing() then
							proc:kill(9)
						end
					end
				end
			end,
		})
	end,
}
