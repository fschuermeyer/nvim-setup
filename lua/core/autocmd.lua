vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#C11B3B", fg = "#F3A3B3" })

-- Highlight for Yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "YankHighlight",
			timeout = 200,
		})
	end,
})

-- File Type Definitions
local filetype_patterns = {
	["gohtmltmpl"] = { "*.tmpl", "*.gohtml", "*.gohtmltmpl" },
	["gotexttmpl"] = { "*.gotexttmpl" },
	["html"] = { "*.twig" },
	["bash"] = { "*.zsh" },
	["hcl"] = { "*.hcl", ".terraformrc", "terraform.rc" },
	["terraform"] = { "*.tf", "*.tfvars" },
	["json"] = { "*.tfstate", "*.tfstate.backup" },
}

for filetype, patterns in pairs(filetype_patterns) do
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = patterns,
		callback = function()
			vim.bo.filetype = filetype
		end,
	})
end

-- Format on Save Additions
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.java", "*.xml" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
