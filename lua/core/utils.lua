local M = {}

function M.get_frontend_root()
    local cwd = vim.fn.getcwd()

    local frontend_path = vim.fn.finddir("frontend", cwd .. ";")
    if frontend_path == "frontend" then
        return cwd .. "/" .. frontend_path
    end

    if frontend_path ~= "" then
        return frontend_path
    end

    local package_json_path = vim.fn.glob(cwd .. "/*/package.json", false, true)
    if #package_json_path > 0 then
        return vim.fn.fnamemodify(package_json_path[1], ":h")
    end

    return cwd
end

function M.is_angular_project()
    local project_root = M.get_frontend_root()
    return vim.fn.filereadable(project_root .. "/angular.json") == 1
end

function M.is_stimulus_project()
    return M.has_dependency("hotwired/stimulus")
end

function M.has_dependency(dep_name)
    local project_root = M.get_frontend_root()
    local package_json_path = project_root .. "/package.json"
    local has_package_json = vim.fn.filereadable(package_json_path)

    if has_package_json == 0 then
        return false
    end

    local lines = vim.fn.readfile(package_json_path)

    for _, line in ipairs(lines) do
        if line:match('"' .. dep_name .. '"') then
            return true
        end
    end

    return false
end

function M.is_jest_project()
    local project_root = M.get_frontend_root()

    if vim.fn.filereadable(project_root .. "/jest.config.js") == 1 or
        vim.fn.filereadable(project_root .. "/jest.config.ts") == 1 then
        return true
    end

    return false
end

function M.is_vitest_project()
    local project_root = M.get_frontend_root()
    if vim.fn.filereadable(project_root .. "/vite.config.js") == 1 or
        vim.fn.filereadable(project_root .. "/vite.config.ts") == 1 then
        return true
    end
    return false
end

function M.find_root(bufnr, markers)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    local root_file = vim.fs.find(markers, { upward = true, path = vim.fs.dirname(fname) })[1]
    if root_file then
        return vim.fs.dirname(root_file)
    else
        return nil -- Kein Root-Verzeichnis gefunden
    end
end

return M
