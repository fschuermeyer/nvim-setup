function is_angular_project()
    local project_root = vim.fn.getcwd()
    return vim.fn.filereadable(project_root .. "/angular.json") == 1
end
