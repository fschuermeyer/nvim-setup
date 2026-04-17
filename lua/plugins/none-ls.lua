return {
	"nvimtools/none-ls.nvim",
	opts = function(_, opts)
		local nls = require("null-ls")

		opts.sources = vim.tbl_extend("force", opts.sources or {}, {
			-- Google Java Format
			nls.builtins.formatting.google_java_format.with({
			extra_args = { "--aosp" },
		}),

			nls.builtins.diagnostics.checkstyle.with({
				command = vim.fn.stdpath("data") .. "/mason/bin/checkstyle",
				-- Hier wird die Google-Konfiguration genutzt, die Checkstyle eingebaut hat
				extra_args = { "-c", vim.fn.expand("~/.config/nvim/lua/plugins/rules/google_checks.xml") },
			}),

			-- XML Formatter
			nls.builtins.formatting.xmllint,
		})
	end,
}
