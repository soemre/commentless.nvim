local utils = require("commentless.utils")
local config = require("commentless.config")

local M = {}

M._hidden = false
M._inherited = {}
M._is_last_line_hidden = false

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
end

function M.toggle()
	M._hidden = not M._hidden
	vim.cmd("normal! zx") -- Update folds
end

function M.foldexpr()
	-- Run at the beginning of each buffer
	if vim.v.lnum == 1 then
		-- Reset the internal state for the new buffer context
		M._is_last_line_hidden = false
	end

	if config.options.hide_following_blank_lines and M._is_last_line_hidden and utils.is_blank_line(vim.v.lnum) then
		return M._hidden and "1" or "0"
	end

	-- Execute `_inherited.foldexpr` for lines that are not part of a comment block.
	if not utils.is_comment(vim.v.lnum) then
		M._is_last_line_hidden = false
		return vim.fn.eval(M._inherited.foldexpr)
	end

	-- A regular comment, either the start of a comment block or part of it.
	M._is_last_line_hidden = true
	return M._hidden and "1" or "0"
end

function M.foldtext()
	-- A comment block always starts with a comment so if it's not a comment,
	-- it should be handled by the inherited foldtext instead.
	if not utils.is_comment(vim.v.foldstart) then
		return vim.fn.eval(M._inherited.foldtext)
	end

	local folded_count = vim.v.foldend - vim.v.foldstart + 1
	local text = config.options.foldtext(folded_count)
	local indention = string.rep(" ", vim.fn.indent(vim.v.foldstart))

	return indention .. text
end

return M
