return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        local on_attach = function(client, bufnr)
            if client.server_capabilities.documentFormattingProvider then
                -- Format on Save
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

        mason_lspconfig.setup_handlers({
            -- default handler for installed servers
            -- fallback to this handler if no specific handler is defined
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
            ["gopls"] = function()
                lspconfig["gopls"].setup({
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
            end,
            ["vtsls"] = function()
                lspconfig["vtsls"].setup({
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
                        }
                    }
                })
            end,
            ["emmet_ls"] = function()
                lspconfig["emmet_ls"].setup({
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
            end,
            ["lua_ls"] = function()
                lspconfig["lua_ls"].setup({
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
                                enable = true
                            },
                        },
                    },
                })
            end,
            ["cssls"] = function()
                lspconfig["cssls"].setup({
                    capabilities = capabilities,
                    on_attach = on_attach_disable_formatting,
                    settings = {
                        init_options = {
                            provideFormatter = false,
                        },
                    },
                })
            end,
            ["stylelint_lsp"] = function()
                lspconfig["stylelint_lsp"].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = {
                        stylelintplus = {
                            autoFixOnSave = true,
                            autoFixOnFormat = true
                        }
                    },
                    filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss", "sass" }
                })
            end,
            ["bashls"] = function()
                lspconfig["bashls"].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    filetypes = { "bash", "sh", "zsh" },
                })
            end,
            ["hls"] = function()
                -- disable hls initalization over lspconfig
            end
        })
    end,
}
