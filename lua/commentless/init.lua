local config = require("commentless.config")
local internal = require("commentless.internal")

local M = {}

function M.setup(options)
	config.setup(options)
	internal.setup()
end

function M.toggle()
	internal.toggle()
end

return M
