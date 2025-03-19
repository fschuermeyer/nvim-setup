return {
    {
        "vuki656/package-info.nvim",
        ft = "json",
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            local packageInfo = require("package-info")
            require("package-info").setup({
                autostart = true,
                hide_up_to_date = true,
            })

            local setKey = function(mode, lhs, rhs, desc, buf)
                vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc, buffer = buf })
            end

            -- Add keybindings for package.json files only
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
                pattern = "package.json",
                callback = function(event)
                    setKey("n", "<leader>cpu", packageInfo.update, "Update dependency", event.buf)
                    setKey("n", "<leader>cpd", packageInfo.delete, "Delete dependency", event.buf)
                    setKey("n", "<leader>cpn", packageInfo.install, "New dependency", event.buf)
                    setKey("n", "<leader>cpc", packageInfo.change_version, "Change version", event.buf)
                end,
            })
        end,
    },
}
