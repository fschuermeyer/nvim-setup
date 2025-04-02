return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        "BurntSushi/ripgrep",
        "andrew-george/telescope-themes",
        "debugloop/telescope-undo.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local layout = require("telescope.actions.layout")

        telescope.setup({
            defaults = {
                path_display = { "truncate" },
                file_ignore_patterns = { "node_modules", "swaggerui", "vendor", ".git", ".run" },
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

        for _, ext in ipairs({ "fzf", "themes", "undo" }) do
            telescope.load_extension(ext)
        end

        -- set keymaps
        local setKey = vim.keymap.set -- for conciseness

        setKey(
            "n",
            "<leader><space>",
            "<cmd>Telescope find_files sort_mru=true<cr>",
            { desc = "Find Files (Root Dir)" }
        )

        -- find hidden files
        setKey("n", "<leader>fh", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Find Hidden Files" })

        setKey("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
        setKey(
            "n",
            "<leader>fb",
            "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
            { desc = "Buffers" }
        )

        setKey("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find Grep" })
        setKey("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find Recent" })
        setKey("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
        setKey("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Find Diagnostics" })
        setKey("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Find Marks" })
        setKey("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "Find Jumplist" })
        setKey("n", "<leader>fp", "<cmd>Telescope man_pages<cr>", { desc = "Find Man Pages" })

        -- git
        setKey("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
        setKey("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
        setKey("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches" })

        -- ui
        setKey("n", "<leader>ut", "<cmd>Telescope themes<cr>", { desc = "UI Themes" })

        -- undo
        setKey("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Find Undo" })
    end,
}
