local M = {}

local utils = require("commentless.utils")
local config = require("commentless.config")

function M.foldexpr(lnum)
	if config.options.hidden then
		if utils.is_comment(lnum) then
			if utils.is_comment(lnum - 1) then
				-- TODO: Docs say returning `=` is slow.
				-- See if there are any alternative implementations.
				return "="
			end
			return ">1"
		end
		return vim.fn.eval(M.inherited_foldexpr)
	end
end

function M.foldtext()
	local indention = string.rep(" ", vim.fn.indent(vim.v.foldstart))
	local numOfLines = vim.v.foldend - vim.v.foldstart + 1
	return indention .. "(" .. numOfLines .. " comments)"
end

function M.setup()
	-- Save the current `foldexpr` before overwriting it
	M.inherited_foldexpr = vim.opt.foldexpr

	-- Overwrite the global fold options
	local opt = vim.opt
	opt.foldmethod = "expr"
	opt.foldexpr = "v:lua.require'commentless.internal'.foldexpr(v:lnum)"
	opt.foldtext = "v:lua.require'commentless.internal'.foldtext()"
	opt.fillchars = "fold: " -- Remove the trailing dots
end

return M
