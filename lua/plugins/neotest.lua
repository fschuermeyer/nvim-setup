local function get_javascript_adapter_test()
    local jestCommand = vim.fn.executable("yarn") == 1 and "yarn jest" or "npx jest"

    if vim.fn.findfile("jest.config.js", ".;") ~= "" or vim.fn.findfile("jest.config.ts", ".;") ~= "" then
        return require("neotest-jest")({
            jestConfigFile = "jest.config.js",
            jestCommand = jestCommand,
        })
    end

    if vim.fn.findfile("vite.config.js", ".;") ~= "" or vim.fn.findfile("vite.config.ts", ".;") ~= "" then
        return require("neotest-vitest")({
            is_test_file = function(file_path)
                if string.match(file_path, "test.ts") then
                    return true
                end
            end,
        })
    end

    return nil
end

return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
            "rcasia/neotest-java",
            "marilari88/neotest-vitest",
        },
        keys = {
            { "<leader>t",  "",                                                                                 desc = "+test" },
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File (Neotest)" },
            { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest (Neotest)" },
            { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last (Neotest)" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary (Neotest)" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel (Neotest)" },
            { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop (Neotest)" },
        },
        config = function()
            local goAdapter = require("neotest-go")({
                args = { "-v" },
            })

            local pyAdapter = require("neotest-python")({
                args = { "-s", "-vv" },
                runner = "pytest",
            })

            local javaAdapter = require("neotest-java")({
                junit_jar = nil,
                incremental_build = true
            })

            local jsAdapter = get_javascript_adapter_test()

            local adapters = { goAdapter, pyAdapter, javaAdapter }

            if jsAdapter then
                table.insert(adapters, jsAdapter)
            end

            ---@diagnostic disable-next-line: missing-fields
            require("neotest").setup({
                adapters = adapters,
                ---@diagnostic disable-next-line: missing-fields
                diagnostic = {
                    enable = true,
                },
            })
        end,
    },
}
