local M = {}

-- Cache for frontend root to avoid repeated file system operations
local frontend_root_cache = {}

function M.get_frontend_root()
    local cwd = vim.fn.getcwd()
    
    -- Return cached value if available
    if frontend_root_cache[cwd] then
        return frontend_root_cache[cwd]
    end

    local frontend_path = vim.fn.finddir("frontend", cwd .. ";")
    if frontend_path == "frontend" then
        frontend_root_cache[cwd] = cwd .. "/" .. frontend_path
        return frontend_root_cache[cwd]
    end

    if frontend_path ~= "" then
        frontend_root_cache[cwd] = frontend_path
        return frontend_root_cache[cwd]
    end

    local package_json_path = vim.fn.glob(cwd .. "/*/package.json", false, true)
    if #package_json_path > 0 then
        frontend_root_cache[cwd] = vim.fn.fnamemodify(package_json_path[1], ":h")
        return frontend_root_cache[cwd]
    end

    frontend_root_cache[cwd] = cwd
    return cwd
end

-- Cache for project type detection to avoid repeated file checks
local project_type_cache = {}

function M.is_angular_project()
    local project_root = M.get_frontend_root()
    
    if project_type_cache[project_root] ~= nil and project_type_cache[project_root].angular ~= nil then
        return project_type_cache[project_root].angular
    end
    
    if not project_type_cache[project_root] then
        project_type_cache[project_root] = {}
    end
    
    project_type_cache[project_root].angular = vim.fn.filereadable(project_root .. "/angular.json") == 1
    return project_type_cache[project_root].angular
end

function M.is_stimulus_project()
    return M.has_dependency("hotwired/stimulus")
end

-- Cache for package.json contents to avoid repeated file reads
local package_json_cache = {}

function M.has_dependency(dep_name)
    local project_root = M.get_frontend_root()
    local package_json_path = project_root .. "/package.json"
    
    -- Check if we have cached data for this package.json
    if package_json_cache[package_json_path] then
        return package_json_cache[package_json_path][dep_name] or false
    end
    
    local has_package_json = vim.fn.filereadable(package_json_path)
    if has_package_json == 0 then
        return false
    end

    -- Read and parse package.json once, then cache all dependencies
    local lines = vim.fn.readfile(package_json_path)
    local content = table.concat(lines, "\n")
    
    -- Initialize cache for this package.json
    package_json_cache[package_json_path] = {}
    
    -- Extract all dependencies at once using pattern matching
    for dep in content:gmatch('"([^"]+)"%s*:%s*"[^"]*"') do
        package_json_cache[package_json_path][dep] = true
    end
    
    return package_json_cache[package_json_path][dep_name] or false
end

function M.is_jest_project()
    local project_root = M.get_frontend_root()
    
    if project_type_cache[project_root] ~= nil and project_type_cache[project_root].jest ~= nil then
        return project_type_cache[project_root].jest
    end
    
    if not project_type_cache[project_root] then
        project_type_cache[project_root] = {}
    end

    local is_jest = vim.fn.filereadable(project_root .. "/jest.config.js") == 1 or
                    vim.fn.filereadable(project_root .. "/jest.config.ts") == 1
    
    project_type_cache[project_root].jest = is_jest
    return is_jest
end

function M.is_vitest_project()
    local project_root = M.get_frontend_root()
    
    if project_type_cache[project_root] ~= nil and project_type_cache[project_root].vitest ~= nil then
        return project_type_cache[project_root].vitest
    end
    
    if not project_type_cache[project_root] then
        project_type_cache[project_root] = {}
    end
    
    local is_vitest = vim.fn.filereadable(project_root .. "/vite.config.js") == 1 or
                      vim.fn.filereadable(project_root .. "/vite.config.ts") == 1
    
    project_type_cache[project_root].vitest = is_vitest
    return is_vitest
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
