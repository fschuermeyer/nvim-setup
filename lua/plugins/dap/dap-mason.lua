return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {},
    },
    config = function() end,
}
