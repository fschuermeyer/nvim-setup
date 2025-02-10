return {
    "rmagatti/alternate-toggler",
    event = { "BufReadPost" },
    config = function()
        require("alternate-toggler").setup({
            alternates = {
                ["const"] = "var"
            }
        })
    end
}
