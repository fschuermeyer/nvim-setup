--------------------------------------------------------------------------------
--- Unified code menu: LSP code actions, codelens and overseer tasks
--- in a single picker interface.
---
--- AI-assisted code generation.
--------------------------------------------------------------------------------

---@class CodeMenuEntry
---@field tag string?
---@field hl string?
---@field title string
---@field desc string
---@field source string?
---@field lang string?
---@field lang_hl string?
---@field action fun()

local M = {}

local get_clients = vim.lsp.get_clients
local get_buf = vim.api.nvim_get_current_buf
local get_cursor = vim.api.nvim_win_get_cursor
local set_hl = vim.api.nvim_set_hl

-- Highlight groups
set_hl(0, "CodeMenuAction", { fg = "#7aa2f7", bold = true })
set_hl(0, "CodeMenuLens", { fg = "#e0af68", bold = true })
set_hl(0, "CodeMenuTaskLocal", { fg = "#ff007c", bold = true })
set_hl(0, "CodeMenuTaskWork", { fg = "#ff9e64", bold = true })
set_hl(0, "CodeMenuTaskGlobal", { fg = "#7dcfff", bold = true })
set_hl(0, "CodeMenuTaskMake", { fg = "#bb9af7", bold = true })
set_hl(0, "CodeMenuDesc", { fg = "#565f89", italic = true })
set_hl(0, "CodeMenuSource", { fg = "#bb9af7" })

-- Language label highlight groups (keyed by lowercase prefix)
set_hl(0, "CodeMenuLangGo", { fg = "#7dcfff", bold = true })
set_hl(0, "CodeMenuLangFrontend", { fg = "#9ece6a", bold = true })
set_hl(0, "CodeMenuLangDev", { fg = "#e0af68", bold = true })
set_hl(0, "CodeMenuLangDefault", { fg = "#bb9af7", bold = true })

---@param entries CodeMenuEntry[]
---@param tag string?
---@param hl string?
---@param title string
---@param desc string?
---@param action fun()
---@param source string?
---@param lang string?
---@param lang_hl string?
local function add(entries, tag, hl, title, desc, action, source, lang, lang_hl)
	entries[#entries + 1] = {
		tag = tag,
		hl = hl,
		title = title,
		desc = desc or "",
		source = source,
		action = action,
		lang = lang,
		lang_hl = lang_hl,
	}
end

-- Action execution ----------------------------------------------------------

---@param action lsp.CodeAction|lsp.Command
---@param client_id integer
---@param bufnr integer
---@param code_action_params table
local function apply_action(action, client_id, bufnr, code_action_params)
	local client = vim.lsp.get_client_by_id(client_id)
	if not client then
		return
	end

	local function execute(a)
		if a.edit then
			vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding)
		end
		if a.command then
			local cmd = type(a.command) == "table" and a.command or a
			-- Pass code action params in context - required for refactoring commands
			client:exec_cmd(cmd, { bufnr = bufnr, params = code_action_params })
		end
	end

	-- Plain Command (not a CodeAction): nothing to resolve
	if type(action.title) == "string" and type(action.command) == "string" then
		execute(action)
		return
	end

	if action.disabled then
		vim.notify(action.disabled.reason, vim.log.levels.ERROR)
		return
	end

	-- Resolve unless the action is already complete, like vim.lsp.buf.code_action does
	if not (action.edit and action.command) and client:supports_method("codeAction/resolve") then
		client:request("codeAction/resolve", action, function(err, resolved)
			if err then
				-- Fall back to the unresolved action if it can do something on its own
				if action.edit or action.command then
					execute(action)
				else
					vim.notify("Code action resolve failed: " .. tostring(err.message), vim.log.levels.ERROR)
				end
				return
			end
			execute(resolved)
		end, bufnr)
	else
		execute(action)
	end
end

-- Collectors ----------------------------------------------------------------

--- Returns the original LSP diagnostics on a line (skips non-LSP sources like nvim-lint).
---@param bufnr integer
---@param row integer
---@return lsp.Diagnostic[]
local function lsp_diagnostics_at(bufnr, row)
	local result = {}
	for _, d in ipairs(vim.diagnostic.get(bufnr, { lnum = row })) do
		-- nvim-lint also sets user_data.lsp, but without a range
		local lsp_diag = d.user_data and d.user_data.lsp
		if lsp_diag and lsp_diag.range then
			result[#result + 1] = lsp_diag
		end
	end
	return result
end

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

	local diagnostics = lsp_diagnostics_at(bufnr, row)

	-- Build params per client like vim.lsp.buf.code_action does
	-- (cursor column is a byte offset, LSP expects the client's offset encoding)
	local params_by_client = {}
	local function make_params(client)
		local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
		params.context = {
			diagnostics = diagnostics,
			triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
		}
		params_by_client[client.id] = params
		return params
	end

	vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", make_params, function(results)
		for client_id, result in pairs(results) do
			if result.result then
				local client = vim.lsp.get_client_by_id(client_id)
				local name = client and client.name or "lsp"
				local params = params_by_client[client_id]
				for _, action in ipairs(result.result) do
					local title = action.title or "untitled"
					if action.disabled then
						title = title .. " (disabled)"
					end
					add(entries, "Action", "CodeMenuAction", title, action.kind, function()
						apply_action(action, client_id, bufnr, params)
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
	for _, item in ipairs(vim.lsp.codelens.get({ bufnr = bufnr })) do
		local lens = item.lens
		if lens.range and lens.range.start.line == row and lens.command then
			local title = lens.command.title or ""
			if not title:match("^0 references$") then
				add(entries, "Lens", "CodeMenuLens", title, lens.command.command, function()
					-- Execute via the client that produced the lens
					local client = vim.lsp.get_client_by_id(item.client_id)
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

	local tf = require("core.taskfile")
	local cwd = vim.fn.getcwd()
	local has_local = tf.has_local_taskfile(cwd)

	require("overseer.template").list({ dir = cwd }, function(templates)
		for _, tmpl in ipairs(templates) do
			-- Strip scope and runner prefixes: "[Global] task go:build" -> "go:build"
			local display = tmpl.name:gsub("^%[%w+%]%s*", ""):gsub("^task%s+", ""):gsub("^make%s+", "")
			if not tf.check_preconditions(display, cwd) then
				goto continue
			end
			local tag, hl
			if tmpl.name:match("^%[Global%]") then
				tag, hl = "Global", "CodeMenuTaskGlobal"
			elseif tmpl.name:match("^%[Work%]") then
				tag, hl = "Work", "CodeMenuTaskWork"
			elseif tmpl.name:match("^make ") then
				tag, hl = "Make", "CodeMenuTaskMake"
			elseif not has_local and tmpl.name:match("^task ") then
				tag, hl = "Work", "CodeMenuTaskWork"
			else
				tag, hl = "Local", "CodeMenuTaskLocal"
			end
			local label, rest, prefix = tf.lang_label(display)
			local lang, lang_hl
			if label then
				display = rest
				local icon = tf.lang_icons[prefix] or tf.default_icon
				lang = icon .. " " .. label
				lang_hl = "CodeMenuLang" .. prefix:sub(1, 1):upper() .. prefix:sub(2)
				if vim.fn.hlID(lang_hl) == 0 then
					lang_hl = "CodeMenuLangDefault"
				end
				-- Language label replaces the Work/Local scope tag
				tag, hl = nil, nil
			end
			add(entries, tag, hl, display, tmpl.desc, function()
				overseer.run_task({ name = tmpl.name, cwd = vim.fn.getcwd() })
			end, nil, lang, lang_hl)
			::continue::
		end
		cb()
	end)
end

-- Picker UI -----------------------------------------------------------------

--- Plain-text label, used for fuzzy matching and the vim.ui.select fallback.
---@param entry CodeMenuEntry
---@return string
local function entry_label(entry)
	local label = entry.tag and ("[" .. entry.tag .. "] ") or ""
	if entry.source then
		label = label .. "[" .. entry.source .. "] "
	end
	if entry.lang then
		label = label .. "[" .. entry.lang .. "] "
	end
	label = label .. entry.title
	if entry.desc ~= "" then
		label = label .. "  (" .. entry.desc .. ")"
	end
	return label
end

--- Highlighted label chunks for snacks.picker.
---@param entry CodeMenuEntry
---@return {[1]: string, [2]: string?}[]
local function format_entry(entry)
	local parts = {}
	if entry.tag then
		parts[#parts + 1] = { "[" .. entry.tag .. "] ", entry.hl }
	end
	if entry.source then
		parts[#parts + 1] = { "[" .. entry.source .. "] ", "CodeMenuSource" }
	end
	if entry.lang then
		parts[#parts + 1] = { "[" .. entry.lang .. "] ", entry.lang_hl or "CodeMenuLangDefault" }
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
			items[i] = { idx = i, text = entry_label(entry), entry = entry }
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
		-- Select entries directly (not labels) so identical titles can't collide
		vim.ui.select(entries, { prompt = "Code Menu", format_item = entry_label }, function(entry)
			if entry then
				entry.action()
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
