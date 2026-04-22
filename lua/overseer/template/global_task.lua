--------------------------------------------------------------------------------
--- Overseer template: exposes global Taskfile tasks as overseer tasks.
---
--- AI-assisted code generation.
--------------------------------------------------------------------------------

local tf = require("core.taskfile")

-- Session cache for global tasks
local _global_tasks_cache = nil
local _global_tasks_loading = false
local _global_tasks_callbacks = {}

local function get_local_task_names(cwd, cb)
  vim.system(
    { "task", "--list-all", "--json" },
    { cwd = cwd, text = true },
    function(out)
      local names = {}
      if out.code == 0 then
        local ok, data = pcall(vim.json.decode, out.stdout)
        if ok and data.tasks then
          for _, t in ipairs(data.tasks) do
            names[t.name] = true
          end
        end
      end
      cb(names)
    end
  )
end

local function get_tasks(cwd, cb)
  local parent_out = {}
  local parent_taskfiles = tf.find_parent_taskfiles(cwd)
  local done = 0
  local total = 1 + #parent_taskfiles

  local function maybe_finish()
    done = done + 1
    if done < total then
      return
    end

    get_local_task_names(cwd, function(local_names)
      local templates = {}
      local seen = {}

      for _, entry in ipairs(parent_out) do
        if not local_names[entry.name] and not seen[entry.name] then
          seen[entry.name] = true
          table.insert(templates, entry)
        end
      end

      -- Use cached global tasks
      if _global_tasks_cache then
        for _, entry in ipairs(_global_tasks_cache) do
          if not local_names[entry.name] and not seen[entry.name] then
            table.insert(templates, entry)
          end
        end
      end

      vim.schedule(function() cb(templates) end)
    end)
  end

  local function parse_tasks(out, prefix, flag, task_dir, results)
    if out.code ~= 0 then
      return
    end
    local ok, data = pcall(vim.json.decode, out.stdout)
    if not ok or not data.tasks then
      return
    end
    for _, t in ipairs(data.tasks) do
      table.insert(results, {
        name = t.name,
        desc = t.desc,
        prefix = prefix,
        flag = flag,
        dir = task_dir,
      })
    end
  end

  -- Load global tasks from cache or fetch once
  if _global_tasks_cache then
    maybe_finish()
  elseif _global_tasks_loading then
    -- Wait for ongoing load
    table.insert(_global_tasks_callbacks, maybe_finish)
  else
    _global_tasks_loading = true
    vim.system({ "task", "-g", "--list-all", "--json" }, { text = true }, function(out)
      local global_out = {}
      parse_tasks(out, "Global", "-g", cwd, global_out)
      _global_tasks_cache = global_out
      _global_tasks_loading = false
      
      maybe_finish()
      
      -- Call any waiting callbacks
      for _, callback in ipairs(_global_tasks_callbacks) do
        callback()
      end
      _global_tasks_callbacks = {}
    end)
  end

  for _, pf in ipairs(parent_taskfiles) do
    vim.system(
      { "task", "--taskfile", pf.path, "--list-all", "--json" },
      { cwd = pf.dir, text = true },
      function(out)
        parse_tasks(out, "Work", "--taskfile=" .. pf.path, pf.dir, parent_out)
        maybe_finish()
      end
    )
  end

  if #parent_taskfiles == 0 then
    maybe_finish()
  end
end

return {
  cache_key = function()
    return vim.fn.getcwd()
  end,
  condition = {
    callback = function()
      return vim.fn.executable("task") == 1
    end,
  },
  generator = function(opts, cb)
    local cwd = vim.fn.getcwd()
    get_tasks(cwd, function(tasks)
      local templates = {}
      for _, t in ipairs(tasks) do
        if tf.check_preconditions(t.name, cwd) then
          table.insert(templates, {
            name = string.format("[%s] %s", t.prefix, t.name),
            desc = t.desc or "",
            builder = function()
              local cmd = { "task" }
              if t.flag == "-g" then
                table.insert(cmd, "-g")
                table.insert(cmd, t.name)
              else
                table.insert(cmd, t.flag)
                table.insert(cmd, t.name)
              end
              return {
                cmd = cmd,
                cwd = (t.flag == "-g") and cwd or t.dir,
              }
            end,
          })
        end
      end
      cb(templates)
    end)
  end,
}
