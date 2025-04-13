local M = {}

function M.is_comment(lnum)
	local indention = vim.fn.indent(lnum)

	-- Substract 1 from `lnum` since the `get_node` expects 0-indexed postions.
	-- However, keep the `indention` variable as it is since the space amount gives the exact postion.
	local node = vim.treesitter.get_node({ pos = { lnum - 1, indention } })

	return node:type():match("comment")
end

return M
