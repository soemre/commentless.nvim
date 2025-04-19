local M = {}

-- HACK: Initial value is discarded at the beginning because the fold state isn't updated yet.
-- So after a call to the `toggle` it folds the comments. Consider refactoring this
-- to ensure `_hidden` is initialized properly before toggling.
M._hidden = true
M._inherited = {}

M._is_last_line_hidden = false

local utils = require("commentless.utils")
local config = require("commentless.config")

function M.foldexpr()
	if vim.v.lnum == 1 then
		M._is_last_line_hidden = false
	end

	if M._is_last_line_hidden and utils.is_blank_line(vim.v.lnum) then
		-- No need to assign `true` to `_is_last_line_hidden` here since it is already `true`
		return M._hidden and "0" or "1"
	end

	-- Keep doing the inherited operations for non-comment lines
	if not utils.is_comment(vim.v.lnum) then
		M._is_last_line_hidden = false
		return vim.fn.eval(M._inherited.foldexpr)
	end

	M._is_last_line_hidden = true
	return M._hidden and "0" or "1"
end

function M.foldtext()
	-- Keep doing the inherited operations for non-comment lines
	if not utils.is_comment(vim.v.foldstart) then
		return vim.fn.eval(M._inherited.foldtext)
	end

	local indention = string.rep(" ", vim.fn.indent(vim.v.foldstart))
	local numOfLines = vim.v.foldend - vim.v.foldstart + 1
	return indention .. config.options.foldtext(numOfLines)
end

function M.setup()
	-- Save the current `foldexpr` before overwriting it
	M._inherited.foldexpr = vim.opt.foldexpr
	M._inherited.foldtext = vim.opt.foldtext

	-- Overwrite the global fold options
	local opt = vim.opt
	local req_int = "v:lua.require'commentless.internal'"
	opt.foldmethod = "expr"
	opt.foldexpr = req_int .. ".foldexpr()"
	opt.foldtext = req_int .. ".foldtext()"

	-- TODO: Is it possible to inherite `fillchars` as well for non-comment folding behavior?
	opt.fillchars = "fold: " -- Remove the trailing dots
end

return M
