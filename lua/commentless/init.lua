local M = {}

local config = require("commentless.config")
local internal = require("commentless.internal")
local utils = require("commentless.utils")

function M.setup(options)
	config.setup(options)
	utils.setup()
	internal.setup()
end

function M.toggle()
	internal._hidden = not internal._hidden
	vim.cmd("normal! zx") -- Update folds
end

return M
