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

function M.hide()
	internal.hide()
end

function M.reveal()
	internal.reveal()
end

function M.is_hidden()
	return internal.is_hidden()
end

return M
