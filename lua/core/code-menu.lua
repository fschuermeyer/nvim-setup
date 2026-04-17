--------------------------------------------------------------------------------
--- Unified code menu: LSP code actions, codelens and overseer tasks
--- in a single picker interface.
---
--- Generated with Claude Opus (Anthropic) via Crush CLI.
--------------------------------------------------------------------------------

---@class CodeMenuEntry
---@field tag string
---@field hl string
---@field title string
---@field desc string
---@field source string?
---@field action fun()

local M = {}

local get_clients = vim.lsp.get_clients
local get_buf = vim.api.nvim_get_current_buf
local get_cursor = vim.api.nvim_win_get_cursor
local set_hl = vim.api.nvim_set_hl

-- Highlight groups
set_hl(0, "CodeMenuAction", { fg = "#7aa2f7", bold = true })
set_hl(0, "CodeMenuLens", { fg = "#e0af68", bold = true })
set_hl(0, "CodeMenuTask", { fg = "#9ece6a", bold = true })
set_hl(0, "CodeMenuDesc", { fg = "#565f89", italic = true })
set_hl(0, "CodeMenuSource", { fg = "#bb9af7" })

---@param entries CodeMenuEntry[]
---@param entry CodeMenuEntry
local function add(entries, tag, hl, title, desc, action, source)
	entries[#entries + 1] = {
		tag = tag,
		hl = hl,
		title = title,
		desc = desc or "",
		source = source,
		action = action,
	}
end

-- Collectors ----------------------------------------------------------------

---@param bufnr integer
---@param row integer
---@param entries CodeMenuEntry[]
---@param cb fun()
local function collect_code_actions(bufnr, row, entries, cb)
	local clients = get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
	if #clients == 0 then
		cb()
		return
	end

	local params = vim.lsp.util.make_range_params(0, "utf-16")
	params.context = { diagnostics = vim.diagnostic.get(bufnr, { lnum = row }) }

	vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(results)
		for client_id, result in pairs(results) do
			if result.result then
				local client = vim.lsp.get_client_by_id(client_id)
				local name = client and client.name or "lsp"
				for _, action in ipairs(result.result) do
					add(entries, "Action", "CodeMenuAction", action.title or "untitled", action.kind, function()
						M._apply_action(action, client_id, bufnr)
					end, name)
				end
			end
		end
		cb()
	end)
end

---@param bufnr integer
---@param row integer
---@param entries CodeMenuEntry[]
local function collect_codelens(bufnr, row, entries)
	local lenses = vim.lsp.codelens.get(bufnr) or {}
	for _, lens in ipairs(lenses) do
		if lens.range and lens.range.start.line == row and lens.command then
			local title = lens.command.title or ""
			if not title:match("^0 references$") then
				add(entries, "Lens", "CodeMenuLens", title, lens.command.command, function()
					local client = get_clients({ bufnr = bufnr, method = "textDocument/codeLens" })[1]
					if client then
						client:exec_cmd(lens.command, { bufnr = bufnr })
					end
				end)
			end
		end
	end
end

---@param entries CodeMenuEntry[]
---@param cb fun()
local function collect_tasks(entries, cb)
	local ok, overseer = pcall(require, "overseer")
	if not ok then
		cb()
		return
	end

	require("overseer.template").list({ dir = vim.fn.getcwd() }, function(templates)
		for _, tmpl in ipairs(templates) do
			add(entries, "Task", "CodeMenuTask", tmpl.name, tmpl.desc, function()
				overseer.run_task({ name = tmpl.name })
			end)
		end
		cb()
	end)
end

-- Action execution ----------------------------------------------------------

---@param action table
---@param client_id integer
---@param bufnr integer
function M._apply_action(action, client_id, bufnr)
	local client = vim.lsp.get_client_by_id(client_id)
	if not client then
		return
	end

	local function execute(a)
		if a.edit then
			vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding or "utf-16")
		end
		if a.command then
			local cmd = type(a.command) == "table" and a.command or a
			client:exec_cmd(cmd, { bufnr = bufnr })
		end
	end

	if action.edit == nil and action.command == nil and client:supports_method("codeAction/resolve") then
		client:request("codeAction/resolve", action, function(err, resolved)
			if err then
				vim.notify("Code action resolve failed: " .. tostring(err.message), vim.log.levels.ERROR)
				return
			end
			execute(resolved)
		end, bufnr)
	else
		execute(action)
	end
end

-- Picker UI -----------------------------------------------------------------

---@param entries CodeMenuEntry[]
local function format_entry(entry)
	local parts = {
		{ "[" .. entry.tag .. "] ", entry.hl },
	}
	if entry.source then
		parts[#parts + 1] = { "[" .. entry.source .. "] ", "CodeMenuSource" }
	end
	parts[#parts + 1] = { entry.title .. " " }
	if entry.desc ~= "" then
		parts[#parts + 1] = { "(" .. entry.desc .. ")", "CodeMenuDesc" }
	end
	return parts
end

---@param entries CodeMenuEntry[]
local function show_picker(entries)
	if #entries == 0 then
		vim.notify("No actions available", vim.log.levels.INFO)
		return
	end

	local ok, snacks = pcall(require, "snacks")
	if ok and snacks.picker then
		local items = {}
		for i, entry in ipairs(entries) do
			local text = entry.desc ~= "" and (entry.title .. "  (" .. entry.desc .. ")") or entry.title
			items[i] = { idx = i, text = text, entry = entry }
		end

		snacks.picker({
			title = "Code Menu",
			items = items,
			preview = false,
			layout = { preset = "select" },
			format = function(item)
				return format_entry(item.entry)
			end,
			confirm = function(picker, item)
				picker:close()
				if item and item.entry then
					item.entry.action()
				end
			end,
		})
	else
		local labels, map = {}, {}
		for _, entry in ipairs(entries) do
			local label = "[" .. entry.tag .. "] " .. entry.title
			if entry.desc ~= "" then
				label = label .. "  (" .. entry.desc .. ")"
			end
			labels[#labels + 1] = label
			map[label] = entry.action
		end
		vim.ui.select(labels, { prompt = "Code Menu" }, function(choice)
			if choice and map[choice] then
				map[choice]()
			end
		end)
	end
end

-- Public API ----------------------------------------------------------------

function M.open()
	local entries = {}
	local bufnr = get_buf()
	local row = get_cursor(0)[1] - 1

	collect_codelens(bufnr, row, entries)

	collect_code_actions(bufnr, row, entries, function()
		collect_tasks(entries, function()
			show_picker(entries)
		end)
	end)
end

return M
