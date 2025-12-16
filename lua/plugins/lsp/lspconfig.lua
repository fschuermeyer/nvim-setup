return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local utils = require("core.utils")

		local setKey = vim.keymap.set -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show references"
				setKey("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				setKey("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show definitions"
				setKey("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show implementations"
				setKey("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show type definitions"
				setKey("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				setKey({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Rename"
				setKey("n", "<leader>cr", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Run Codelens action"
				setKey("n", "<leader>ci", vim.lsp.codelens.run, opts) -- run codelens action

				opts.desc = "Refresh Codelens"
				setKey("n", "<leader>cu", vim.lsp.codelens.refresh, opts) -- refresh codelens

				opts.desc = "Go to previous diagnostic"
				setKey("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				setKey("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				setKey("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				setKey("n", "<leader>cs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		local on_attach = function(client, bufnr)
			-- Format on Save
			if client.server_capabilities.documentFormattingProvider then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							async = false,
							timeout_ms = 3000,
						})
					end,
				})
			end

			-- Enable inlay hints and refresh codelens on buffer enter, write, and insert leave
			if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "" then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

				vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
					buffer = bufnr,
					callback = vim.lsp.codelens.refresh,
				})
			end
		end

		local on_attach_disable_formatting = function(client, _)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("gopls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = false,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		vim.lsp.config("golangci_lint_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			init_options = {
				command = {
					"golangci-lint",
					"run",
					"--output.json.path",
					"stdout",
					"--output.text.path",
					"/dev/null",
					"--show-stats=false",
				},
			},
		})

		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				vtsls = {
					experimental = {
						maxInlayHintLength = 30,
					},
				},
				typescript = {
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "all" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = true },
					},
					implementationCodeLens = { enabled = true },
					referencesCodeLens = { enabled = true },
				},
				javascript = {
					inlayHints = {
						parameterNames = { enabled = "all" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
					},
					referencesCodeLens = { enabled = true },
				},
			},
		})

		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					hint = {
						enable = true,
					},
				},
			},
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
			on_attach = on_attach_disable_formatting,
			settings = {
				init_options = {
					provideFormatter = false,
				},
			},
		})

		vim.lsp.config("stylelint_lsp", {
			capabilities = capabilities,
			on_attach = on_attach_disable_formatting,
			settings = {
				stylelintplus = {
					autoFixOnSave = true,
					autoFixOnFormat = true,
				},
			},
			filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss", "sass" },
			root_dir = function(bufnr, on_dir)
				local outDir = utils.find_root(bufnr, {
					".stylelintrc",
					".stylelintrc.mjs",
					".stylelintrc.cjs",
					".stylelintrc.js",
					".stylelintrc.json",
					".stylelintrc.yaml",
					".stylelintrc.yml",
					"stylelint.config.mjs",
					"stylelint.config.cjs",
					"stylelint.config.js",
				})

				on_dir(outDir)
			end,
		})

		vim.lsp.config("bashls", {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "bash", "sh", "zsh" },
		})

		vim.lsp.config("stimulus_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(bufnr, on_dir)
				if utils.is_stimulus_project() then
					on_dir(utils.find_root(bufnr, {
						"package.json",
					}))
				end
			end,
		})

		vim.lsp.config("angularls", {
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(bufnr, on_dir)
				if utils.is_angular_project() then
					on_dir(utils.find_root(bufnr, {
						"angular.json",
					}))
				end
			end,
		})

		vim.lsp.config("hls", {
			capabilities = capabilities,
			on_attach = on_attach_disable_formatting,
			settings = {
				format = {
					enable = false,
				},
				init_options = {
					provideFormatter = false,
				},
			},
		})
	end,
}
