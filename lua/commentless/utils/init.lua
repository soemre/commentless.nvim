local M = {}

function M.is_comment(lnum)
	local syntax = require("commentless.utils.ft").get_comment_syntax()
	local line = vim.fn.getline(lnum)
	return line:match(syntax) ~= nil
end

return M
