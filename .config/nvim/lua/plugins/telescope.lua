return { {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope-fzf-native.nvim',
    'folke/trouble.nvim',
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fag', function()
      require('telescope.builtin').live_grep({ additional_args = { '--hidden', '--no-ignore' } })
    end, {})
    vim.keymap.set('n', '<leader>fz',
      function() require 'telescope.builtin'.grep_string { shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } end,
      {})
    vim.keymap.set('n', '<leader>faz',
      function() require 'telescope.builtin'.grep_string { additional_args = { '--hidden', '--no-ignore' }, shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } end,
      {})
    vim.keymap.set('n', '<leader>faf', function()
      require "telescope.builtin".find_files({ hidden = true, no_ignore = true })
    end, {})
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    -- resume
    vim.keymap.set('n', '<Leader>fr', builtin.resume, {})
    local trouble = require("trouble.providers.telescope")
    require('telescope').setup {
      defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
          i = {
            ["<C-h>"] = "which_key",
            ["<M-]>"] = require('telescope.actions').cycle_history_next,
            ["<M-[>"] = require('telescope.actions').cycle_history_prev,
            ["<c-t>"] = trouble.open_with_trouble
          },
          n = { ["<c-t>"] = trouble.open_with_trouble },
        }
      },
    }
    require('telescope').load_extension('fzf')
  end
},
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
}
