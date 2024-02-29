return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "typescript", "python", "bash",
          "css", "json", "tsx", "yaml", "gitignore", "regex", "haskell" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
        incremental_selection = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["am"] = "@function.outer",
              ["im"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },
              ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[A"] = "@parameter.inner",
            },
          },

        }
      })
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevelstart = 99
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    config = function()
      local keymap = vim.keymap.set
      keymap({ "o", "x" }, "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>")
      keymap({ "o", "x" }, "av", "<cmd>lua require('various-textobjs').value('outer')<CR>")

      keymap({ "o", "x" }, "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>")
      keymap({ "o", "x" }, "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>")
    end
  },
}
