local config = require("commentless.config")

local M = {}

M._namespace_id = nil

function M.is_comment(lnum)
	local indention = vim.fn.indent(lnum)

	-- Substract 1 from `lnum` since the `get_node` expects 0-indexed postions.
	-- However, keep the `indention` variable as it is since the space amount gives the exact postion.
	local node = vim.treesitter.get_node({ pos = { lnum - 1, indention } })

	return node:type():match("comment")
end

function M.is_blank_line(lnum)
	local line = vim.fn.getline(lnum)
	return (line:match("^%s*$") == "")
end

-- On top of the `config.options.foldtext` provides indention and filling functionality.
function M.foldtext(lnum, folded_count, have_fill)
	local text = config.options.foldtext(folded_count)
	local indention = string.rep(" ", vim.fn.indent(lnum))

	if not have_fill then
		return indention .. text
	end

	local fill = string.rep(" ", #vim.fn.getline(lnum) - #indention - #text)
	return indention .. text .. fill
end

function M.hide_line(lnum)
	vim.api.nvim_buf_set_extmark(0, M._namespace_id, lnum - 1, 0, {
		virt_text = { { M.foldtext(lnum, 1, true), "Comment" } },
		virt_text_pos = "overlay",
		-- end_col = #vim.fn.getline(lnum + 1),
		-- conceal = "",
		invalidate = true,
	})
end

function M.show_lines()
	vim.api.nvim_buf_clear_namespace(0, M._namespace_id, 0, -1)
end

function M.setup()
	M._namespace_id = vim.api.nvim_create_namespace("commentless_namespace")
end

return M
