return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip").setup({
					history = true,
					region_check_events = "InsertEnter",
					delete_check_events = "TextChanged,InsertLeave",
				})
			end,
		},
	},
}
