return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			tex = { "tex-fmt" },
		},
		formatters = {
			["tex-fmt"] = {
				prepend_args = { "--config", vim.fn.expand("~/.config/nvim/lua/plugins/tex-fmt.toml") },
			},
		},
		format_on_save = function(bufnr)
			if vim.bo[bufnr].filetype ~= "tex" then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
}
