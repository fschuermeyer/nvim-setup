--------------------------------------------------------------------------------
--- Taskfile utilities: locate Taskfile paths and detect language-specific
--- markers for automatic task discovery.
---
--- AI-assisted code generation.
--------------------------------------------------------------------------------

local M = {}

local taskfile_names = { "Taskfile.yml", "taskfile.yml", "Taskfile.yaml", "taskfile.yaml" }

--- Separator used between the language segment and the rest of a task name
--- (e.g. "go:test"). Change this to switch to a different convention.
M.separator = ":"

--- Filesystem markers that must exist for a language-prefixed task to be shown.
M.lang_markers = {
	go = { "go.mod" },
	frontend = { "package.json", "frontend/package.json" },
}

--- Display labels for language-prefixed tasks. Missing entries fall back to a
--- capitalized version of the prefix.
M.lang_labels = {
	go = "Go",
	frontend = "Frontend",
	dev = "Dev",
}

--- Nerd Font icons for language-prefixed tasks. Missing entries fall back to
--- M.default_icon.
M.lang_icons = {
	go = "",
	frontend = "",
	dev = "",
}

M.default_icon = ""

--- Returns the language segment and remainder of a task name, split on the
--- configured separator. Returns nil if the name has no separator.
function M.split_prefix(name)
	local esc = M.separator:gsub("(%W)", "%%%1")
	local prefix, rest = name:match("^(.-)" .. esc .. "(.*)$")
	if prefix and prefix ~= "" then
		return prefix, rest
	end
	return nil
end

--- Returns a display label and remainder for a task name, or nil if the task
--- has no language prefix.
function M.lang_label(name)
	local prefix, rest = M.split_prefix(name)
	if not prefix then
		return nil
	end
	local label = M.lang_labels[prefix] or (prefix:sub(1, 1):upper() .. prefix:sub(2))
	return label, rest, prefix
end

--- Returns the Nerd Font icon for a task's language prefix, or nil if the task
--- has no prefix. Falls back to M.default_icon for unknown prefixes.
function M.lang_icon(name)
	local prefix = M.split_prefix(name)
	if not prefix then
		return nil
	end
	return M.lang_icons[prefix] or M.default_icon, prefix
end

function M.check_preconditions(name, cwd)
	local prefix = M.split_prefix(name)
	local markers = prefix and M.lang_markers[prefix]
	if markers then
		for _, marker in ipairs(markers) do
			if vim.uv.fs_stat(cwd .. "/" .. marker) then
				return true
			end
		end
		return false
	end
	return true
end

function M.has_local_taskfile(cwd)
	for _, name in ipairs(taskfile_names) do
		if vim.uv.fs_stat(cwd .. "/" .. name) then
			return true
		end
	end
	return false
end

function M.find_parent_taskfiles(cwd)
	local home = vim.uv.os_homedir()
	local results = {}
	local dir = vim.fn.fnamemodify(cwd, ":h")
	while dir and dir ~= "/" and dir ~= "" and dir ~= home do
		for _, name in ipairs(taskfile_names) do
			local path = dir .. "/" .. name
			if vim.uv.fs_stat(path) then
				table.insert(results, { path = path, dir = dir })
				break
			end
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return results
end

return M
