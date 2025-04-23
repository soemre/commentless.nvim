local config = require("commentless.config")

local M = {}

function M.is_comment(lnum)
	local indention = vim.fn.indent(lnum)

	-- Substract 1 from `lnum` since `get_node` expects 0-indexed postions and `lnum` is 1-indexed.
	local node = vim.treesitter.get_node({ pos = { lnum - 1, indention } })

	return node:type():match("comment")
end

function M.is_blank_line(lnum)
	local line = vim.fn.getline(lnum)
	return (line:match("^%s*$") == "")
end

function M.reload()
	if config.options.hide_current_comment then
		vim.cmd("normal! zX") -- Update folds
	else
		vim.cmd("normal! zx") -- Update folds
	end
end

return M
