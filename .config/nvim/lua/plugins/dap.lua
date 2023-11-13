return {
  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      local dap = require("dap")
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }
      local custom_adapter = 'pwa-node-custom'
      dap.adapters[custom_adapter] = function(cb, config)
        if config.preLaunchTask then
          vim.notify('Running preLaunchTask: ' .. config.preLaunchTask)
          vim.fn.system(config.preLaunchTask)
          vim.notify('Finished running preLaunchTask: ' .. config.preLaunchTask)
        end
        config.type = 'pwa-node'
        dap.run(config)
      end
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            name = 'Compile & Debug Main Process (tsc + pwa-node)',
            type = custom_adapter,
            request = 'launch',
            preLaunchTask = 'tsc --sourceMap',
            program = '${file}',
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            protocol = "inspector",
            runtimeExecutable = 'node',
            skipFiles = {
              "<node_internals>/**",
              "node_modules/**"
            },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**"
            }
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            skipFiles = {
              "<node_internals>/**",
            },
            outFiles = {
              "${workspaceFolder}/out/**/*.js"
            },
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node with ts-node/esm)",
            cwd = "${workspaceFolder}",
            runtimeArgs = {
              "--loader",
              "ts-node/esm"
            },
            runtimeExecutable = "node",
            args = {
              "${file}"
            },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = {
              "<node_internals>/**",
              "node_modules/**"
            },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**"
            }
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node with ts-node)",
            cwd = "${workspaceFolder}",
            runtimeArgs = {
              "--nolazy", "-r", "ts-node/register"
            },
            runtimeExecutable = "node",
            args = {
              "${file}"
            },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = {
              "<node_internals>/**",
              "node_modules/**"
            },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**"
            }
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          }
        }
      end
    end,
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
      { "<leader>dO", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>do", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
