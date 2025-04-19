local M = {}

M.options = {}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults(), options)
end

function M.defaults()
	local defaults = {
		hide_single_comments = true,
		hide_following_blank_lines = true,
		foldtext = function(folded_count)
			return "(" .. folded_count .. " comments)"
		end,
	}
	return defaults
end

return M
