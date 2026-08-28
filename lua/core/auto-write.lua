local DEBOUNCE_MS = 250

local state = {
	enabled = false,
	timer = nil,
	augroup = nil,
}

local function should_save(bo, name)
	return bo.buftype == ""
		and bo.modifiable
		and bo.modified
		and not bo.readonly
		and name ~= ""
end

local function save_current_buffer()
	local buf = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	if not should_save(vim.bo[buf], vim.api.nvim_buf_get_name(buf)) then
		return
	end
	vim.api.nvim_buf_call(buf, function()
		vim.cmd("silent! write")
	end)
end

local function schedule_save()
	if state.timer then
		state.timer:stop()
		state.timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(save_current_buffer))
	end
end

local function stop()
	if state.timer then
		state.timer:stop()
		state.timer:close()
		state.timer = nil
	end
	if state.augroup then
		vim.api.nvim_del_augroup_by_id(state.augroup)
		state.augroup = nil
	end
end

local function start()
	stop()
	state.timer = vim.uv.new_timer()
	state.augroup = vim.api.nvim_create_augroup("AutoWrite", { clear = true })
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = state.augroup,
		callback = schedule_save,
	})
end

local function toggle()
	state.enabled = not state.enabled
	if state.enabled then
		start()
	else
		stop()
	end
	vim.notify("Auto-write: " .. (state.enabled and "on" or "off"))
end

vim.keymap.set("n", "<leader>ua", toggle, { desc = "Toggle Auto Write" })
