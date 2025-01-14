return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        "BurntSushi/ripgrep",
        "andrew-george/telescope-themes",
        "ThePrimeagen/refactoring.nvim",
        "debugloop/telescope-undo.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local layout = require("telescope.actions.layout")

        telescope.setup({
            defaults = {
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                        ["<C-p>"] = layout.toggle_preview,           -- toggle preview
                    },
                },
            },
            extensions = {
                undo = {
                    use_delta = true,
                },
            },
        })

        -- Enable Preview for gohtml files in Telescope
        vim.api.nvim_create_autocmd("User", {
            pattern = "TelescopePreviewerLoaded",
            callback = function(args)
                local gotmpl = { "%.gohtmltmpl$", "%.gohtml$", "%.gotmpl$", "%.tmpl$" }
                for _, ext in ipairs(gotmpl) do
                    if args.data and args.data.bufname and args.data.bufname:match(ext) then
                        vim.cmd("setlocal filetype=gohtmltmpl")
                    end
                end
            end,
        })

        for _, ext in ipairs({ "fzf", "themes", "refactoring", "undo" }) do
            telescope.load_extension(ext)
        end

        -- set keymaps
        local keymap = vim.keymap -- for conciseness
        keymap.set(
            "n",
            "<leader><space>",
            "<cmd>Telescope find_files sort_mru=true<cr>",
            { desc = "Find Files (Root Dir)" }
        )
        keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
        keymap.set(
            "n",
            "<leader>fb",
            "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
            { desc = "Buffers" }
        )

        keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find Grep" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find Recent" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })

        -- git
        keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
        keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
        keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches" })

        -- code action
        keymap.set({ "n", "x" }, "<leader>cf", function()
            require('telescope').extensions.refactoring.refactors()
        end, { desc = "Refactoring Actions" })

        -- ui
        keymap.set("n", "<leader>ut", "<cmd>Telescope themes<cr>", { desc = "UI Themes" })

        -- undo
        keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Find Undo" })
    end,
}
