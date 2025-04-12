local M = {}

local config = require("commentless.config")
local internal = require("commentless.internal")

function M.setup(options)
	config.setup(options)
	internal.setup()
end

function M.toggle()
	config.options.hidden = not config.options.hidden
	vim.cmd("normal! zx") -- Update folds
end

return M
