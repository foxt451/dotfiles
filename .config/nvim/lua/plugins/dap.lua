return {
  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    'Weissle/persistent-breakpoints.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('persistent-breakpoints').setup {
        load_breakpoints_event = { "BufReadPost" }
      }
    end
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      "microsoft/vscode-js-debug",
    },
    config = function()
      local utils = require("dap-vscode-js.utils")
      require("dap-vscode-js").setup({
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        debugger_path = utils.join_paths(utils.get_runtime_dir(), "lazy/vscode-js-debug"),
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log",
        -- log_file_level = vim.log.levels.TRACE,
      })
      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            name = "TSX",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            skipFiles = {
              "<node_internals>/**",
              "${workspaceFolder}/node_modules/**"
            },
            runtimeExecutable = "tsx",
          },
          {
            type = "pwa-node",
            name = "TSX + internal",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            runtimeExecutable = "tsx",
          },
          {
            type = "pwa-node",
            name = "Debug Current Test File",
            request = "launch",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = {
              "run",
              "${relativeFile}"
            },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            skipFiles = {
              "<node_internals>/**",
              "**/node_modules/**"
            },
            smartStep = true,
          },
          -- {
          --   type = "pwa-node",
          --   request = "launch",
          --   name = "Launch file",
          --   program = "${file}",
          --   cwd = "${workspaceFolder}",
          --   console = "integratedTerminal",
          --   skipFiles = {
          --     "<node_internals>/**",
          --   },
          --   outFiles = {
          --     "${workspaceFolder}/out/**/*.js"
          --   },
          -- },
          -- {
          --   type = "pwa-node",
          --   request = "launch",
          --   name = "Launch Current File (pwa-node with ts-node/esm)",
          --   cwd = "${workspaceFolder}",
          --   runtimeArgs = {
          --     "--loader",
          --     "ts-node/esm"
          --   },
          --   runtimeExecutable = "node",
          --   args = {
          --     "${file}"
          --   },
          --   sourceMaps = true,
          --   protocol = "inspector",
          --   console = "integratedTerminal",
          --   skipFiles = {
          --     "<node_internals>/**",
          --     "node_modules/**"
          --   },
          --   resolveSourceMapLocations = {
          --     "${workspaceFolder}/**",
          --     "!**/node_modules/**"
          --   }
          -- },
          -- {
          --   type = "pwa-node",
          --   request = "launch",
          --   name = "Launch Current File (pwa-node with ts-node)",
          --   cwd = "${workspaceFolder}",
          --   runtimeExecutable = "ts-node",
          --   args = { '${file}' },
          --   protocol = 'inspector',
          --   skipFiles = { '<node_internals>/**', 'node_modules/**' },
          --   console = "integratedTerminal",
          --
          -- },
          -- {
          --   type = "pwa-node",
          --   request = "attach",
          --   console = "integratedTerminal",
          --   name = "Attach",
          --   processId = require 'dap.utils'.pick_process,
          --   cwd = "${workspaceFolder}",
          -- },
          -- {
          --   type = "pwa-node",
          --   request = "launch",
          --   name = "Debug Jest Tests",
          --   runtimeExecutable = "node",
          --   runtimeArgs = {
          --     "./node_modules/jest/bin/jest.js",
          --     "--runInBand",
          --   },
          --   rootPath = "${workspaceFolder}",
          --   cwd = "${workspaceFolder}",
          --   console = "integratedTerminal",
          -- }
        }
      end
      require('dap.ext.vscode').load_launchjs(nil,
        { ['pwa-node'] = { 'javascript', 'javascriptreact', 'typescriptreact', 'typescript' } })
    end
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap").defaults.fallback.external_terminal = {
        command = "alacritty",
        args = { "--hold", "-e" }
      }
      require("dap").defaults.fallback.terminal_win_cmd = [[belowright new +let\ b:dap_terminal\ =\ 1]]
      -- require("dap").defaults.fallback.force_external_terminal = true
      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function(args)
          local buf = args.buf
          local ok, _ = pcall(vim.api.nvim_buf_get_var, buf, "dap_terminal")
          if ok then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end,
        group = vim.api.nvim_create_augroup("dap-aautoclose", { clear = true }),
        pattern = "*"
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function() require("dap.ext.autocompl").attach() end,
        group = vim.api.nvim_create_augroup("repl-autocompl", { clear = true }),
        pattern = "dap-repl"
      })
    end,
    keys = {
      { "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end,          desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                          desc = "Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end,                     desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                     desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                             desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                         desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                              desc = "Down" },
      {
        "<leader>dk",
        function()
          -- find all buffers with dap_terminal set and kill them and their terminals
          local bufs = vim.api.nvim_list_bufs()
          for _, buf in ipairs(bufs) do
            local ok, _ = pcall(vim.api.nvim_buf_get_var, buf, "dap_terminal")
            if ok then
              -- -- get the channel id using local option 'channel'
              -- local channel = vim.api.nvim_buf_get_option(buf, "channel")
              -- -- echo the channel id
              -- print("channel: ", channel)
              -- vim.fn.chanclose(channel)
              -- -- wipeout the buffer
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
        desc = "Kill all the terminals that are dap"
      },
      { "<leader>dl", function() require("dap").run_last() end,         desc = "Run Last" },
      { "<leader>dO", function() require("dap").step_out() end,         desc = "Step Out" },
      { "<leader>do", function() require("dap").step_over() end,        desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,            desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,      desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,          desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,        desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      -- -- add a command to close the window that was used by the debug terminal
      -- { "<leader>dx", function()
      --   -- get the buffer that is used by the terminal
      --   -- this MAY NOT be the current buffer
      --   -- do not use the current buffer!
      --   -- NO nvim_get_current_buf
      --   local buf = vim.api.nvim_list_bufs()

    },
  },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = {
  --     "mfussenegger/nvim-dap",
  --   },
  --   keys = {
  --     { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
  --     { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
  --   },
  --   config = function(_, opts)
  --     local dap = require("dap")
  --     local dapui = require("dapui")
  --     dapui.setup(opts)
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open({})
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapui.close({})
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapui.close({})
  --     end
  --   end,
  -- },
}
