return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			tex = { "tex-fmt" },
			lua = { "stylua" },
		},
		formatters = {
			["tex-fmt"] = {
				prepend_args = { "--config", vim.fn.expand("~/.config/nvim/lua/plugins/rules/tex-fmt.toml") },
			},
		},
		format_on_save = function(bufnr)
			local allowed = { tex = true, lua = true }
			if not allowed[vim.bo[bufnr].filetype] then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
}
