return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		-- Snacks.image already renders LaTeX as real typeset images via
		-- pdflatex; render-markdown's own latex2text path only substitutes
		-- unicode lookalikes and conflicts with it (checkhealth [conflicts]).
		latex = { enabled = false },
	},
}
