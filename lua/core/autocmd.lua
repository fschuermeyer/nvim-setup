local setKey = vim.keymap.set

-- Export ENV Variables for other Toolings
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function()
		local file = vim.fn.expand("%:p")
		local ft = vim.bo.filetype
		local rel = vim.fn.expand("%:.")
		local dir = vim.fn.expand("%:p:h")
		local ext = vim.fn.expand("%:e")

		vim.env.NVIM_FILE = file ~= "" and file or nil
		vim.env.NVIM_REL_FILE = rel ~= "" and rel or nil
		vim.env.NVIM_FILE_DIR = dir ~= "" and dir or nil
		vim.env.NVIM_FILETYPE = ft ~= "" and ft or nil
		vim.env.NVIM_EXT = ext ~= "" and ext or nil
	end,
})

vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#C11B3B", fg = "#F3A3B3" })

-- High contrast mode for bright sunlight (toggle with <leader>ux):
-- lime line numbers, brackets and inlay hints, gold comments
local high_contrast_enabled = false

local function apply_high_contrast()
	for _, hl in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
		vim.api.nvim_set_hl(0, hl, { fg = "#39FF14" })
	end
	for _, hl in ipairs({ "@punctuation.bracket", "MatchParen" }) do
		vim.api.nvim_set_hl(0, hl, { fg = "#39FF14", bold = true })
	end
	for _, hl in ipairs({ "Comment", "@comment" }) do
		vim.api.nvim_set_hl(0, hl, { fg = "#FFD700", italic = true })
	end
	for _, hl in ipairs({ "LspInlayHint", "@lsp.type.inlayHint" }) do
		vim.api.nvim_set_hl(0, hl, { fg = "#39FF14", bg = "#1F3D14", bold = true })
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		if high_contrast_enabled then
			apply_high_contrast()
		end
	end,
})

setKey("n", "<leader>ux", function()
	high_contrast_enabled = not high_contrast_enabled
	if high_contrast_enabled then
		apply_high_contrast()
	else
		vim.cmd.colorscheme(vim.g.colors_name)
	end
	vim.notify("High contrast: " .. (high_contrast_enabled and "on" or "off"))
end, { desc = "Toggle High Contrast Mode" })

-- Highlight for Yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({
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
		vim.lsp.buf.format({
			async = false,
			filter = function(client)
				if vim.bo.filetype == "java" then
					return client.name == "null-ls"
				end
				return true
			end,
		})
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*_test.go",
	callback = function()
		setKey("n", "<leader>tg", "<cmd>GoTestFunc<CR>", { desc = "Test Golang", buffer = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		setKey("n", "ga", function()
			local current_file = vim.fn.expand("%:p")
			local alternative_file
			if current_file:match("_test%.go$") then
				alternative_file = current_file:gsub("_test%.go$", ".go")
			else
				alternative_file = current_file:gsub("%.go$", "_test.go")
			end
			if vim.fn.filereadable(alternative_file) == 1 then
				vim.cmd("edit " .. vim.fn.fnameescape(alternative_file))
			else
				vim.notify("Alternate file not found: " .. alternative_file, vim.log.levels.WARN)
			end
		end, { desc = "toggle test file", buffer = true })
	end,
})

-- Deprecated Code Highlighting
local deprecated = {
	hl_group = "DeprecatedHighlight",
	pattern = "\\c\\w*deprecated\\w*",
	sign = "💀",
	ns = vim.api.nvim_create_namespace("deprecated_signs"),
}

vim.api.nvim_set_hl(0, deprecated.hl_group, { fg = "#FFD700" })

local function mark_deprecated_lines(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, deprecated.ns, 0, -1)
	for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
		if line:lower():match("%w*deprecated%w*") then
			vim.api.nvim_buf_set_extmark(bufnr, deprecated.ns, i - 1, 0, {
				sign_text = deprecated.sign,
				sign_hl_group = deprecated.hl_group,
			})
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.fn.matchadd(deprecated.hl_group, deprecated.pattern)
		mark_deprecated_lines(vim.api.nvim_get_current_buf())
	end,
})
