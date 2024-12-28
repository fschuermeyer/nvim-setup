return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- import mason
        local mason = require("mason")
        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            automatic_installation = true,
            -- list of servers for mason to install
            ensure_installed = {
                "bashls",                          -- Bash language support
                "cssls",                           -- CSS language support
                "css_variables",                   -- CSS Variables support
                "docker_compose_language_service", -- Docker Compose language support
                "dockerls",                        -- Dockerfile language support
                "emmet_ls",                        -- Emmet language support
                "eslint",                          -- ESLint language support
                "gopls",                           -- Go language server
                "groovyls",                        -- Groovy language support
                "hls",                             -- Haskell language server
                "html",                            -- HTML language support
                "intelephense",                    -- PHP language support
                "jedi_language_server",            -- Python language server
                "jsonls",                          -- JSON language support
                "kotlin_language_server",          -- Kotlin language support
                "lua_ls",                          -- Lua language server
                "pyright",                         -- Python language server
                "tailwindcss",                     -- Tailwind CSS language support
                "ts_ls",                           -- TypeScript language support
                "yamlls",                          -- YAML language support
                "vtsls",                           -- Vue and TypeScript support
                "volar",                           -- Vue.js language support
                "stimulus_ls",                     -- Stimulus language support
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "autoflake",                -- Python tool
                "debugpy",                  -- Python debugger
                "delve",                    -- Go debugger
                "eslint_d",                 -- Faster ESLint
                "gofumpt",                  -- Go formatter
                "goimports",                -- Go imports formatter
                "golangci-lint-langserver", -- Go linter
                "hadolint",                 -- Dockerfile linter
                "haskell-debug-adapter",    -- Haskell debugger
                "isort",                    -- Python import sorter
                "markdownlint-cli2",        -- Markdown linter
                "marksman",                 -- Markdown language server
                "php-cs-fixer",             -- PHP formatter
                "php-debug-adapter",        -- PHP debugger
                "phpactor",                 -- PHP language server
                "phpcs",                    -- PHP linter
                "prettier",                 -- Code formatter
                "ruff",                     -- Python linter
                "shfmt",                    -- Shell formatter
                "sqlfluff",                 -- SQL formatter and linter
                "stylua",                   -- Lua formatter
                "taplo",                    -- TOML language server
                "markdown-toc",             -- Markdown TOC generator
                "shellcheck",               -- Shell script analysis
                "shfmt",                    -- Shell script formatter
                "ruff-lsp",                 -- Python linter support
                "js-debug-adapter",         -- JavaScript debug adapter
            },
        })
    end,
}
