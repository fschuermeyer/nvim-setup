-- Highlight groups for LaTeX problematic words
vim.api.nvim_set_hl(0, "TexFirstPersonSingular", { fg = "#FF6B6B", bold = true }) -- Red
vim.api.nvim_set_hl(0, "TexFirstPersonPlural", { fg = "#FFA500", bold = true }) -- Orange
vim.api.nvim_set_hl(0, "TexSecondPerson", { fg = "#FFD700", bold = true }) -- Gold
vim.api.nvim_set_hl(0, "TexColloquial", { fg = "#DA70D6", bold = true }) -- Orchid/Purple
vim.api.nvim_set_hl(0, "TexSubjective", { fg = "#00CED1", bold = true }) -- Cyan
vim.api.nvim_set_hl(0, "TexImprecise", { fg = "#FF69B4", bold = true }) -- Hot Pink
vim.api.nvim_set_hl(0, "TexWeakVerbs", { fg = "#40E0D0", bold = true }) -- Turquoise
vim.api.nvim_set_hl(0, "TexTemporalVague", { fg = "#FFB6C1", bold = true }) -- Light Pink

-- Highlight problematic words in .tex files (case-insensitive)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		-- First person singular (Red)
		vim.fn.matchadd("TexFirstPersonSingular", "\\c\\<ich\\>")
		vim.fn.matchadd("TexFirstPersonSingular", "\\c\\<mein\\(e[nmrs]\\?\\)\\?\\>")
		vim.fn.matchadd("TexFirstPersonSingular", "\\c\\<mir\\>")
		vim.fn.matchadd("TexFirstPersonSingular", "\\c\\<mich\\>")

		-- First person plural (Orange)
		vim.fn.matchadd("TexFirstPersonPlural", "\\c\\<wir\\>")
		vim.fn.matchadd("TexFirstPersonPlural", "\\c\\<uns\\(er[enmrs]\\?\\)\\?\\>")

		-- Second person (Gold)
		vim.fn.matchadd("TexSecondPerson", "\\c\\<du\\>")
		vim.fn.matchadd("TexSecondPerson", "\\c\\<dein\\(e[nmrs]\\?\\)\\?\\>")
		vim.fn.matchadd("TexSecondPerson", "\\c\\<dir\\>")
		vim.fn.matchadd("TexSecondPerson", "\\c\\<dich\\>")

		-- Colloquial/Filler words (Purple)
		vim.fn.matchadd("TexColloquial", "\\c\\<halt\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<quasi\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<irgendwie\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<sozusagen\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<eigentlich\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<letztendlich\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<gewissermaßen\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<ziemlich\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<relativ\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<eher\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<durchaus\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<sehr\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<ganz\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<recht\\>")
		vim.fn.matchadd("TexColloquial", "\\c\\<eben\\>")

		-- Subjective/Evaluative expressions (Cyan)
		vim.fn.matchadd("TexSubjective", "\\c\\<offensichtlich\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<klar\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<natürlich\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<selbstverständlich\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<eindeutig\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<leider\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<glücklicherweise\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<erfreulicherweise\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<sicherlich\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<zweifellos\\>")
		vim.fn.matchadd("TexSubjective", "\\c\\<offenbar\\>")

		-- Imprecise/Problematic words (Hot Pink)
		vim.fn.matchadd("TexImprecise", "\\c\\<man\\>")
		vim.fn.matchadd("TexImprecise", "\\c\\<etc\\.\\?\\>")
		vim.fn.matchadd("TexImprecise", "\\c\\<usw\\.\\?\\>")
		vim.fn.matchadd("TexImprecise", "\\c\\<könnte\\>")
		vim.fn.matchadd("TexImprecise", "\\c\\<würde\\>")
		vim.fn.matchadd("TexImprecise", "\\c\\<dürfte\\>")
		vim.fn.matchadd("TexImprecise", "\\c\\<möchte\\>")

		-- Weak/Passive verbs (Turquoise)
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<machen\\>")
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<tun\\>")
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<tut\\>")
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<geben\\>")
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<bekommen\\>")
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<erhalten\\>")
		vim.fn.matchadd("TexWeakVerbs", "\\c\\<erfolgen\\>")

		-- Common Anglicism (Light Pink)
		vim.fn.matchadd("TexTemporalVague", "\\c\\<macht Sinn\\>")
		vim.fn.matchadd("TexTemporalVague", "\\cmacht\\s\\+Sinn")
	end,
})
