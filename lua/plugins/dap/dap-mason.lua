return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
        },
    },
    config = function() end,
}
