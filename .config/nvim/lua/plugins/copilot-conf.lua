return { {
  -- "zbirenbaum/copilot.lua",
  -- cmd = "Copilot",
  -- event = "InsertEnter",
  -- build = ":Copilot auth",
  -- opts = {
  --   suggestion = {
  --     auto_trigger = true,
  --   },
  -- },
  "github/copilot.vim",
  config = function()
    vim.keymap.set('i', '<M-l>', 'copilot#Accept("")', {
      expr = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
  end
} }
