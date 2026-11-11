-- main branch: matches nvim-treesitter main (the master branch needs
-- nvim-treesitter.configs, which main no longer has). Keymaps are explicit.
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter-textobjects").setup({
			-- Automatically jump forward to textobj, similar to targets.vim
			select = { lookahead = true },
			move = { set_jumps = true },
		})

		local select = require("nvim-treesitter-textobjects.select")
		local swap = require("nvim-treesitter-textobjects.swap")
		local move = require("nvim-treesitter-textobjects.move")
		local map = vim.keymap.set

		-- { lhs suffix, query, description }; mapped as a<x> / i<x> (outer / inner)
		local selects = {
			{ "=", "assignment", "assignment" },
			{ ":", "property", "object property" }, -- JS/TS only: after/queries/ecma/textobjects.scm
			{ "a", "parameter", "parameter/argument" },
			{ "i", "conditional", "conditional" },
			{ "l", "loop", "loop" },
			{ "f", "call", "function call" },
			{ "m", "function", "method/function definition" },
			{ "c", "class", "class" },
		}
		for _, s in ipairs(selects) do
			for prefix, part in pairs({ a = "outer", i = "inner" }) do
				map({ "x", "o" }, prefix .. s[1], function()
					select.select_textobject("@" .. s[2] .. "." .. part, "textobjects")
				end, { desc = ("Select %s part of a %s"):format(part, s[3]) })
			end
		end
		for lhs, q in pairs({
			["l="] = { "@assignment.lhs", "left hand side of an assignment" },
			["r="] = { "@assignment.rhs", "right hand side of an assignment" },
			["l:"] = { "@property.lhs", "left part of an object property" },
			["r:"] = { "@property.rhs", "right part of an object property" },
		}) do
			map({ "x", "o" }, lhs, function()
				select.select_textobject(q[1], "textobjects")
			end, { desc = "Select " .. q[2] })
		end

		for _, s in ipairs({
			{ "a", "@parameter.inner", "argument" },
			{ "p", "@property.outer", "property" },
			{ "f", "@function.outer", "function" },
		}) do
			map("n", "<leader>m" .. s[1], function()
				swap.swap_next(s[2])
			end, { desc = "Swap " .. s[3] .. " with next" })
			map("n", "<leader>m" .. s[1]:upper(), function()
				swap.swap_previous(s[2])
			end, { desc = "Swap " .. s[3] .. " with previous" })
		end

		-- ]x / [x jump to starts, ]X / [X to ends
		for _, m in ipairs({
			{ "f", "@call.outer", "function call" },
			{ "m", "@function.outer", "method/function def" },
			{ "c", "@class.outer", "class" },
			{ "i", "@conditional.outer", "conditional" },
			{ "l", "@loop.outer", "loop" },
		}) do
			local key, q, what = m[1], m[2], m[3]
			local function jump(fn)
				return function()
					move[fn](q, "textobjects")
				end
			end
			map({ "n", "x", "o" }, "]" .. key, jump("goto_next_start"), { desc = "Next " .. what .. " start" })
			map({ "n", "x", "o" }, "[" .. key, jump("goto_previous_start"), { desc = "Prev " .. what .. " start" })
			map({ "n", "x", "o" }, "]" .. key:upper(), jump("goto_next_end"), { desc = "Next " .. what .. " end" })
			map({ "n", "x", "o" }, "[" .. key:upper(), jump("goto_previous_end"), { desc = "Prev " .. what .. " end" })
		end
		map({ "n", "x", "o" }, "]s", function()
			move.goto_next_start("@local.scope", "locals")
		end, { desc = "Next scope" })
		map({ "n", "x", "o" }, "]z", function()
			move.goto_next_start("@fold", "folds")
		end, { desc = "Next fold" })

		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		-- vim way: ; goes to the direction you were moving.
		map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- make builtin f, F, t, T also repeatable with ; and ,
		map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}
