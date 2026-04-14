return {
	"rmagatti/alternate-toggler",
	event = { "BufReadPost" },
	config = function()
		require("alternate-toggler").setup({
			alternates = {
				{ "true", "false" },
				{ "True", "False" },
				{ "TRUE", "FALSE" },
				{ "Yes", "No" },
				{ "YES", "NO" },
				{ "1", "0" },
				{ "<", ">" },
				{ "(", ")" },
				{ "[", "]" },
				{ "{", "}" },
				{ '"', "'" },
				{ '""', "''" },
				{ "+", "-" },
				{ "===", "!==" },
				{ "==", "!=" },
				{ "public", "private", "protected" },
				{ "const", "var" },
				{ "none", "block" },
				{ "left", "center", "right" },
				{ "float", "double" },
			},
		})
	end,
}
