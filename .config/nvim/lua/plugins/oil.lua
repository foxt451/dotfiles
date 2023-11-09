vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
