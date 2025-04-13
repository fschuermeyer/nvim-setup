local prefix = "<leader>o"

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                "nvim-tree/nvim-web-devicons",
            },
            opts = {
                code = {
                    disable_background = true,
                },
            },
        },
    },
    init = function()
        vim.treesitter.language.register("javascript", "dataviewjs")
        vim.treesitter.language.register("sql", "dataview")
    end,
    keys = {
        { prefix .. "o", "<cmd>ObsidianQuickSwitch<CR>",   desc = "Obsidian: Quick Switch" },
        { prefix .. "f", "<cmd>ObsidianSearch<CR>",        desc = "Obsidian: Search" },
        { prefix .. "r", "<cmd>ObsidianRename<CR>",        desc = "Obsidian: Rename" },
        { prefix .. "n", "<cmd>ObsidianNew<CR>",           desc = "Obsidian: New Note" },
        { prefix .. "b", "<cmd>ObsidianBacklinks<CR>",     desc = "Obsidian: Backlinks" },
        { prefix .. "x", "<cmd>RenderMarkdown toggle<CR>", desc = "Obsidian: Render Markdown" },
        { prefix .. "l", "<cmd>ObsidianLinks<CR>",         desc = "Obsidian: Links" },
        { prefix .. "c", "<cmd>ObsidianOpen<CR>",          desc = "Obsidian: Open" },
    },
    opts = {
        use_advanced_uri = true,
        open_app_forground = true,
        wiki_link_func = "use_alias_only",
        note_id_func = function(title)
            return title
        end,
        follow_url_func = function(url)
            vim.ui.open(url)
        end,

        disable_frontmatter = true,

        workspaces = {
            {
                name = "knowledge",
                path = os.getenv("OBSIDIAN_VAULT_PATH") or "~/Knowledge",
            },
        },
        daily_notes = {
            folder = "Journal",
            date_format = "%d.%m.%Y",
        },
        templates = {
            subdir = "Templates",
            date_format = "%d.%m.%Y",
            time_format = "%H:%M:%S",
        },
        attachments = {
            img_folder = "assets"
        },
    },
}
