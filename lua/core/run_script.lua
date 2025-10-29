local setKey = vim.keymap.set
local formatters = {
    raw = {
        pipeline = "",
        filetype = "",
        shortcut = "<leader>rr",
        arg_shortcut = "<leader>rar",
        desc = "Run Script (raw)",
    },
    html = {
        pipeline = "",
        filetype = "html",
        shortcut = "<leader>rh",
        arg_shortcut = "<leader>rah",
        desc = "Run Script (html)",
    },
    xml = {
        pipeline = "",
        filetype = "xml",
        shortcut = "<leader>rx",
        arg_shortcut = "<leader>rax",
        desc = "Run Script (xml)",
    },
    json = {
        pipeline = " | jq",
        filetype = "json",
        shortcut = "<leader>rj",
        arg_shortcut = "<leader>raj",
        desc = "Run Script (json)",
    },
}

local output_buf = nil

local function run_script(formatter, with_args)
    local file = vim.fn.expand("%")
    if file == "" then
        vim.notify("no file found", vim.log.levels.ERROR)
        return
    end

    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
    if not string.match(first_line, "^#!.*bash") then
        vim.notify("no valid shebang exists", vim.log.levels.ERROR)
        return
    end

    local args_str = ""
    if with_args then
        local args = vim.fn.input(formatter.desc .. " with Args:")
        if args ~= "" then
            local args_list = vim.split(args, " ", { trimempty = true })
            for i, arg in ipairs(args_list) do
                args_list[i] = vim.fn.shellescape(arg)
            end
            args_str = table.concat(args_list, " ")
        end
    end

    local cmd = "bash " .. vim.fn.shellescape(file)
    if args_str ~= "" then
        cmd = cmd .. " " .. args_str
    end
    cmd = cmd .. formatter.pipeline

    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        local err_msg = table.concat(output, "\n")
        vim.notify("Run script failed:\n" .. err_msg, vim.log.levels.ERROR)
        return
    end

    local original_win = vim.api.nvim_get_current_win()
    if not output_buf or not vim.api.nvim_buf_is_valid(output_buf) then
        vim.cmd("vsplit")
        local new_win = vim.api.nvim_get_current_win()
        output_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(new_win, output_buf)
    else
        -- More efficient buffer visibility check using win_findbuf
        local buf_wins = vim.fn.win_findbuf(output_buf)
        if #buf_wins == 0 then
            vim.cmd("vsplit")
            local new_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(new_win, output_buf)
        end
    end

    if formatter.filetype ~= "" then
        vim.bo[output_buf].filetype = formatter.filetype
    end

    vim.bo[output_buf].modifiable = true
    vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, output)
    vim.bo[output_buf].modifiable = false
    vim.api.nvim_set_current_win(original_win)
end

local group = vim.api.nvim_create_augroup("ScriptKeymaps", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" then
            for _, formatter in pairs(formatters) do
                setKey("n", formatter.shortcut, function() run_script(formatter) end,
                    { buffer = true, desc = formatter.desc })

                if formatter.arg_shortcut then
                    setKey("n", formatter.arg_shortcut, function() run_script(formatter, true) end,
                        { buffer = true, desc = formatter.desc .. " with Args" })
                end
            end
        end
    end,
})

setKey("n", "<leader>rc", function()
    if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
        vim.api.nvim_buf_delete(output_buf, { force = true })
    end
end, { desc = "Close Output Buffer" })
