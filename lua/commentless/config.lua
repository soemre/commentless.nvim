local M = {}

M.options = {}

function M.setup(options)
	vim.tbl_deep_extend("force", {}, M.defaults(), options)
end

function M.defaults()
	local defaults = {
		hidden = false,
	}
	return defaults
end

return M
