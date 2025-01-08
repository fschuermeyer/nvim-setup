local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.2)
    local height = opts.height or math.floor(vim.o.lines * 0.2)

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local function highlight_dashed_lines(buf, lines)
    for i, line in ipairs(lines) do
        if line == "---" then
            vim.api.nvim_buf_add_highlight(buf, -1, "diffIndexLine", i - 1, 0, -1)
        end
    end
end

vim.api.nvim_set_hl(0, "BoldTitle", { bold = true, fg = "#4B5FEC" })

local function show_lsp_info_in_buffer(buf)
    local clients = vim.lsp.get_clients()
    local lines = {}

    if #clients == 0 then
        table.insert(lines, "Keine aktiven LSP-Clients gefunden.")
    else
        table.insert(lines, "Aktive LSP-Clients:")
        table.insert(lines, "---")

        for _, client in ipairs(clients) do
            table.insert(lines, "Client-Name: " .. client.name)
            table.insert(lines, "Server-ID: " .. client.id)

            table.insert(lines, "---")
        end
    end

    vim.api.nvim_buf_set_option(buf, "readonly", false)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_add_highlight(buf, -1, "BoldTitle", 0, 0, -1)
    highlight_dashed_lines(buf, lines)

    vim.api.nvim_buf_set_option(buf, "readonly", true)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
end

local toggle_lsp_info = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf }

        show_lsp_info_in_buffer(state.floating.buf)
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("LspClients", toggle_lsp_info, {})

vim.keymap.set("n", "<leader>cl", ":LspClients<CR>", { noremap = true, silent = true, desc = "LSP Clients anzeigen" })
