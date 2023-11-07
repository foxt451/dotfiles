return {
	{
		"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
		config = function () 
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "typescript", "python", "bash", "css", "json", "tsx", "yaml", "gitignore" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },  
				incremental_selection = {
					enable = true,
				},
				textobjects = {
					select = {
						enable=true,
lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
					},
					move = {
						enable = true,
						set_jumps = true,				
						goto_next_start = {
							["]m"] = "@function.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
						},
					},

				}
			})
			vim.opt.foldmethod="expr"
			vim.opt.foldexpr="nvim_treesitter#foldexpr()"
			vim.opt.foldenable=false 
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter"
		},
	}
}
