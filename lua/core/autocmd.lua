-- Export buffer context as env vars for external tools (Task, Crush, etc.)
local function update_nvim_env()
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
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = update_nvim_env,
})

vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#C11B3B", fg = "#F3A3B3" })

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
		vim.keymap.set("n", "<leader>tg", "<cmd>GoTestFunc<CR>", { desc = "Test Golang", buffer = true })
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
