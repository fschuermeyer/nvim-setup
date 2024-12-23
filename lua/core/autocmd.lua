vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#C11B3B", fg = "#F3A3B3" })

-- Highlight, was gejankt wurde
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "YankHighlight",
			timeout = 200,
		})
	end,
})
