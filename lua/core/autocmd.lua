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
