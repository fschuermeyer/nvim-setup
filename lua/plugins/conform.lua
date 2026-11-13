return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			tex = { "tex-fmt" },
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		formatters = {
			["tex-fmt"] = {
				prepend_args = { "--config", vim.fn.expand("~/.config/nvim/lua/plugins/rules/tex-fmt.toml") },
			},
			["clang-format"] = {
				prepend_args = function(_, ctx)
					local found =
						vim.fs.find({ ".clang-format", "_clang-format" }, { path = ctx.dirname, upward = true })[1]

					if found then
						return { "--style=file" }
					end

					return { "--style=file:" .. vim.fn.expand("~/.config/nvim/lua/plugins/rules/.clang-format") }
				end,
			},
		},
		format_on_save = function(bufnr)
			local allowed = { tex = true, lua = true, c = true, cpp = true }
			if not allowed[vim.bo[bufnr].filetype] then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
}
