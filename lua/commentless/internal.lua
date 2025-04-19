local utils = require("commentless.utils")
local config = require("commentless.config")

local M = {}

M._hidden = false
M._inherited = {}
M._current_comment_block_index = -1
M._is_last_line_hidden = false

function M.foldexpr()
	if vim.v.lnum == 1 then
		M._is_last_line_hidden = false

		if config.options.hide_single_comments and not M._hidden then
			utils.show_lines()
		end
	end

	if config.options.hide_following_blank_lines and M._is_last_line_hidden and utils.is_blank_line(vim.v.lnum) then
		-- No need to assign `true` to `_is_last_line_hidden` here since it is already `true`
		return M._hidden and "1" or "0"
	end

	-- Keep doing the inherited operations for non-comment lines
	if not utils.is_comment(vim.v.lnum) then
		if config.options.hide_single_comments and M._hidden and M._current_comment_block_index == vim.v.lnum - 1 then
			utils.hide_line(M._current_comment_block_index)
		end

		M._is_last_line_hidden = false
		return vim.fn.eval(M._inherited.foldexpr)
	end

	if not M._is_last_line_hidden then
		M._current_comment_block_index = vim.v.lnum
		M._is_last_line_hidden = true
	end
	return M._hidden and "1" or "0"
end

function M.foldtext()
	-- Keep doing the inherited operations for non-comment lines
	if not utils.is_comment(vim.v.foldstart) then
		return vim.fn.eval(M._inherited.foldtext)
	end

	local folded_count = vim.v.foldend - vim.v.foldstart + 1
	return utils.foldtext(vim.v.foldstart, folded_count, false)
end

function M.setup()
	local opt = vim.opt

	-- Save the current `foldexpr` before overwriting it
	M._inherited.foldexpr = opt.foldexpr
	M._inherited.foldtext = opt.foldtext

	-- Overwrite the global fold options
	local req_int = "v:lua.require'commentless.internal'"
	opt.foldmethod = "expr"
	opt.foldexpr = req_int .. ".foldexpr()"
	opt.foldtext = req_int .. ".foldtext()"

	-- TODO: Is it possible to inherite `fillchars` as well for non-comment folding behavior?
	opt.fillchars = "fold: " -- Remove the trailing dots
end

return M
