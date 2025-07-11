return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path",   -- source for file system paths
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
        },
        "saadparwaiz1/cmp_luasnip",             -- for autocompletion
        "rafamadriz/friendly-snippets",         -- useful snippets
        "onsails/lspkind.nvim",                 -- vs-code like pictograms
        "kristijanhusak/vim-dadbod-completion", -- completion for vim-dadbod-ui
        {
            "zbirenbaum/copilot-cmp",
            opts = {},
            config = function(_, opts)
                local copilot_cmp = require("copilot_cmp")
                copilot_cmp.setup(opts)

                local lspkind = require("lspkind")
                lspkind.init({
                    symbol_map = {
                        Copilot = "",
                    },
                })

                vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#CA2222" })
            end,
        },
    },
    config = function()
        local cmp = require("cmp")

        local ls = require("luasnip")

        -- extend htmlangular with html snippets
        ls.filetype_extend("htmlangular", { "html" })
        ls.filetype_extend("gohtmltmpl", { "html" })

        vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        require("luasnip.loaders.from_vscode").lazy_load()

        require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/" } })

        cmp.setup({
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                    side_padding = 0,
                },
            },
            completion = {
                completeopt = "menu,menuone,preview,noinsert",
            },
            preselect = cmp.PreselectMode.Item,
            snippet = { -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    ls.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-Space>"] = cmp.mapping.complete(),     -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(),            -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = "copilot" },
                { name = "vim-dadbod-completion" }, -- completion for vim-dadbod-ui
                { name = "luasnip" },               -- snippets
                { name = "nvim_lsp" },
                { name = "path" },                  -- file system paths
                { name = "buffer" },                -- text within current buffer
            }),
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "
                    kind.menu = "    (" .. (strings[2] or "") .. ")"

                    return kind
                end,
                expandable_indicator = true,
            },
            experimental = {
                -- required for inline preview of completion items
                ghost_text = true,
            },
        })
    end,
}
