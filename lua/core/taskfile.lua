--------------------------------------------------------------------------------
--- Taskfile utilities: locate Taskfile paths and detect language-specific
--- markers for automatic task discovery.
---
--- AI-assisted code generation.
--------------------------------------------------------------------------------

local M = {}

local taskfile_names = { "Taskfile.yml", "taskfile.yml", "Taskfile.yaml", "taskfile.yaml" }

M.lang_markers = {
	["^go%-"] = { "go.mod" },
	["^frontend%-"] = { "package.json", "frontend/package.json" },
}

function M.check_preconditions(name, cwd)
	for pattern, markers in pairs(M.lang_markers) do
		if name:match(pattern) then
			for _, marker in ipairs(markers) do
				if vim.uv.fs_stat(cwd .. "/" .. marker) then
					return true
				end
			end
			return false
		end
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
