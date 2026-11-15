-- Insert an include guard into new or empty C header files
-- (BufReadPost covers files created by file explorers like neo-tree)
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
	pattern = "*.h",
	callback = function(args)
		local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
		local is_empty = #lines == 1 and lines[1] == ""
		if not is_empty then
			return
		end

		local filename = vim.fn.fnamemodify(args.file, ":t")
		local guard = (filename:upper():gsub("[^%w]", "_")) -- city.h -> CITY_H
		vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {
			"#ifndef " .. guard,
			"#define " .. guard,
			"",
			"",
			"#endif /* " .. guard .. " */",
		})
		vim.api.nvim_win_set_cursor(0, { 4, 0 })
	end,
})

-- Open (or create) the header file matching the current C source file
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = function(args)
		local source = vim.api.nvim_buf_get_name(args.buf)
		if vim.fn.fnamemodify(source, ":e") ~= "c" then
			return -- skip .h files, which can also have filetype "c"
		end

		vim.keymap.set("n", "<leader>ch", function()
			local header = vim.fn.fnamemodify(source, ":r") .. ".h"
			vim.cmd.edit(vim.fn.fnameescape(header))
		end, { buffer = args.buf, desc = "Open/create matching header" })
	end,
})

-- Insert a Unity test skeleton into new or empty files matching tests/test_*.c
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
	pattern = "*/tests/test_*.c",
	callback = function(args)
		local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
		if not (#lines == 1 and lines[1] == "") then
			return
		end

		local module = vim.fn.fnamemodify(args.file, ":t:r"):gsub("^test_", "")
		vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {
			'#include "unity.h"',
			"",
			'#include "path/' .. module .. '.h" // TODO: adjust module path',
			"",
			"void setUp(void) {}",
			"void tearDown(void) {}",
			"",
			"static void test_" .. module .. "_example(void) {",
			'\tTEST_IGNORE_MESSAGE("TODO: implement me!");',
			"}",
			"",
			"int main(void) {",
			"\tUNITY_BEGIN();",
			"\tRUN_TEST(test_" .. module .. "_example);",
			"\treturn UNITY_END();",
			"}",
		})
	end,
})
