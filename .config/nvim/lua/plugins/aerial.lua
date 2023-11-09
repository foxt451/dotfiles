vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

return {
  'stevearc/aerial.nvim',
  opts = {
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
}
