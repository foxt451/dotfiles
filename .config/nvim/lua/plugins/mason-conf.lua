return {
	{
		"williamboman/mason.nvim",
		config = function()
			require('mason').setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"mason.nvim",
			"nvim-lspconfig"
		},
		config = function()
			local lspconfig = require('lspconfig')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			local default_setup = function(server)
				lspconfig[server].setup({
					capabilities = lsp_capabilities,
				})
			end
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "tsserver", "eslint", "jsonls" },
				handlers = {
					default_setup,
					-- tsserver = function()
					-- 	require('lspconfig').tsserver.setup({
					-- 		capabilities = lsp_capabilities,
					-- 		init_options = {
					-- 			preferences = {
					-- 				includeInlayParameterNameHints = 'all',
					-- 				-- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					-- 				-- includeInlayFunctionParameterTypeHints = true,
					-- 				-- includeInlayVariableTypeHints = true,
					-- 				-- includeInlayPropertyDeclarationTypeHints = true,
					-- 				-- includeInlayFunctionLikeReturnTypeHints = true,
					-- 				-- includeInlayEnumMemberValueHints = true,
					-- 				-- importModuleSpecifierPreference = 'non-relative',
					-- 			},
					-- 		},
					-- 	})
					-- end,
					lua_ls = function()
						require('lspconfig').lua_ls.setup({
							settings = {
								Lua = {
									runtime = {
										version = 'LuaJIT'
									},
									diagnostics = {
										globals = { 'vim' },
									},
									workspace = {
										library = {
											vim.env.VIMRUNTIME,
										}
									}
								}
							}
						})
					end,
				},
			})
		end
	},
}
