local logo = [[
`8.`888b           ,8'  8 8888          ,8.       ,8.
 `8.`888b         ,8'   8 8888         ,888.     ,888.
  `8.`888b       ,8'    8 8888        .`8888.   .`8888.
   `8.`888b     ,8'     8 8888       ,8.`8888. ,8.`8888.
    `8.`888b   ,8'      8 8888      ,8'8.`8888,8^8.`8888.
     `8.`888b ,8'       8 8888     ,8' `8.`8888' `8.`8888.
      `8.`888b8'        8 8888    ,8'   `8.`88'   `8.`8888.
       `8.`888'         8 8888   ,8'     `8.`'     `8.`8888.
        `8.`8'          8 8888  ,8'       `8        `8.`8888.
         `8.`           8 8888 ,8'         `         `8.`8888.

github.com/fschuermeyer/nvim-setup
]]

return {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
        dashboard = {
            preset = {
                header = logo,
            },
            sections = {
                { section = "header" },
                { section = "keys",  gap = 1, padding = 1 },
                {
                    icon = " ",
                    title = "Recent Files",
                    cwd = true,
                    section = "recent_files",
                    indent = 2,
                    padding = 1,
                },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
                { section = "startup" },
            },
        },
        indent = {
            enabled = true,
            animate = {
                duration = {
                    step = 5,
                    total = 250,
                },
            },
        },
        input = {
            icon = "",
        },
        scope = { enabled = true },
        scroll = { enabled = true },
        notifier = { enabled = true },
        explorer = { enabled = false },
        picker = { enabled = true },
        bigfile = { enabled = false },
        scratch = { enabled = false },
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#FFA500" }) -- Orange Dashboard Header

        local setKey = vim.keymap.set                                       -- for conciseness

        setKey("n", "<leader>cR", Snacks.rename.rename_file, { desc = "Rename File" })

        setKey("n", "<leader>bd", function()
            Snacks.bufdelete()
        end, { desc = "Delete Buffer" })

        setKey("n", "<leader>bo", function()
            Snacks.bufdelete.other()
        end, { desc = "Delete Other Buffers" })

        local setToggle = Snacks.toggle.option -- for conciseness

        setToggle("wrap", { name = "Line Wrap" }):map("<leader>uw")
        setToggle("number", { name = "Line Numbers" }):map("<leader>un")
        setToggle("relativenumber", { name = "Relative Line Numbers" }):map("<leader>ur")
        setToggle("cursorline", { name = "Cursorline" }):map("<leader>uc")
    end,
}
