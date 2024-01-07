vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return {
  'stevearc/oil.nvim',
  config = function()
    require('oil').setup({
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      }
    })
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
