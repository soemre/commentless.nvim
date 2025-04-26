local config = require("commentless.config")
local internal = require("commentless.internal")

local M = {}

function M.setup(options)
	config.setup(options)
	internal.setup()

	local sub_cmds = {
		["toggle"] = M.toggle,
		["hide"] = M.hide,
		["reveal"] = M.reveal,
	}

	vim.api.nvim_create_user_command("Commentless", function(cmd)
		local sub_cmd = cmd.args == "" and "toggle" or cmd.args
		local ok = pcall(sub_cmds[sub_cmd])
		if not ok then
			vim.notify("[commentless.commands]: Unknown command", vim.log.levels.ERROR)
		end
	end, {
		desc = "Fold/Unfold all comments",
		nargs = "*",
		complete = function()
			local keys = {}
			for key in pairs(sub_cmds) do
				table.insert(keys, key)
			end
			return keys
		end,
	})
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
