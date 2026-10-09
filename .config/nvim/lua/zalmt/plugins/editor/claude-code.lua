-- simple_toggle (plain `:ClaudeCode`) only hides/shows the existing terminal and
-- ignores args while it's alive. Kill the job so the new args actually apply.
local function fresh_claude(args)
	local bufnr = require("claudecode.terminal").get_active_terminal_bufnr()
	if bufnr then
		local job = vim.b[bufnr].terminal_job_id
		if job then
			vim.fn.jobstop(job)
		end
		vim.api.nvim_buf_delete(bufnr, { force = true })
	end
	vim.cmd("ClaudeCode" .. (args and " " .. args or ""))
end

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		require("claudecode").setup({})

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "*claude*",
			callback = function(ev)
				local buf = ev.buf
				local opts = { buffer = buf, silent = true }

				-- Esc drops to normal mode (consistent with other splits)
				vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)

				-- Ctrl+Shift+C: exit terminal mode so you can visually select and yank
				vim.keymap.set("t", "<C-S-c>", "<C-\\><C-n>", opts)
				vim.keymap.set("v", "<C-S-c>", '"+y', opts)

				local function send_clipboard()
					local clip = vim.fn.getreg("+")
					local chan = vim.b[buf].terminal_job_id
					if chan and clip ~= "" then
						vim.api.nvim_chan_send(chan, clip)
					end
				end

				-- Ctrl+Shift+V: send clipboard contents directly to the terminal job
				vim.keymap.set("t", "<C-S-v>", send_clipboard, opts)

				-- p in normal mode: send clipboard to terminal (instead of pasting into buffer)
				vim.keymap.set("n", "p", function()
					send_clipboard()
					vim.cmd("startinsert")
				end, opts)
			end,
		})
	end,
	keys = {
		{ "<leader>a", nil, desc = "Claude Code" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>an", function() fresh_claude() end, desc = "New Claude chat" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", function() fresh_claude("--resume") end, desc = "Resume Claude (pick session)" },
		{ "<leader>aC", function() fresh_claude("--continue") end, desc = "Continue last Claude session" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
