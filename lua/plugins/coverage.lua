return {
    "andythigpen/nvim-coverage",
    version = "*",
    keys = {
        { "<leader>ccc", "<cmd>Coverage<cr>",        desc = "Load coverage file and display" },
        { "<leader>cct", "<cmd>CoverageToggle<cr>",  desc = "Toggle coverage display" },
        { "<leader>ccs", "<cmd>CoverageSummary<cr>", desc = "Show summary of coverage" },
    },
    config = function()
        require("coverage").setup({
            auto_reload = true,
            lang = {
                java = {
                    coverage_file = "build/reports/jacoco/test/jacoco.xml"
                },
            }
        })
    end,
}
