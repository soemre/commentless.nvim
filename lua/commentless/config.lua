local M = {}

M.options = {}

function M.setup(options)
	-- Overwrite the options in the default config with the given ones
	M.options = vim.tbl_deep_extend("force", {}, M.defaults(), options)
end

function M.defaults()
	local defaults = {
		hide_following_blank_lines = true,
		hide_current_comment = true,
		foldtext = function(folded_count)
			return "(" .. folded_count .. " comments)"
		end,
	}
	return defaults
end

return M
