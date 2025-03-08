local dap = require("dap")
local dap_vscode_js = require("dap-vscode-js")

dap_vscode_js.setup({
    debugger_path = vim.fn.stdpath("data") .. "/mason/packages/vscode-js-debug",
    adapters = { "node", "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    --args = {os.getenv('HOME') .. '/path/to/vscode-node-debug2/out/src/nodeDebug.js'},
    args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/n" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Run this file",
    program = function()
      return vim.fn.expand("%:p")
    end,
    pythonPath = "/usr/bin/python3.12",
    justMyCode = false,            -- Debug all code, including libraries
  },
  {
    type = "python",
    request = "launch",
    name = "Run this file (Torch Dynamo Logs, Mamba)",
    program = function()
      return vim.fn.expand("%:p")
    end,
    pythonPath = "/usr/bin/python3.12",
    justMyCode = false,            -- Debug all code, including libraries
    env = { TORCH_LOGS="+dynamo", TORCHDYNAMO_VERBOSE="1", PYTHONPATH="/app/mamba" }
  },
  {
    type = "python",
    request = "launch",
    name = "Run with Arguments",
    program = function()
      return vim.fn.expand("%:p")
    end,
    pythonPath = "/usr/bin/python3.12",
    justMyCode = false,            -- Debug all code, including libraries
    args = function()
        -- Prompt for input, defaulting to the last used arguments
        last_args = vim.fn.input("Enter arguments: ", last_args or "", "file")
        return vim.split(last_args, " ")  -- Split into argument list
    end
  },

}

dap.configurations.javascript = {
    {
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
        trace = true, -- Enable verbose tracing
    },
}

dap.configurations.typescript = {
    {
        type = "node",
        name = "Launch Node",
        request = "attach",
        program = "${workspaceFolder}/node_modules/.bin/nest",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "node",
        runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/nest", "start" },
        outFiles = { "${workspaceFolder}/dist/**/*.js" },
        trace = true, -- Enable verbose tracing
    },
    {
        name = "Launch Node2",
        type = "node2",
        request = "launch",
        program = vim.fn.getcwd() .. "/src/main.ts",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        outFiles = { "${workspaceFolder}/dist/**/*.js" },
        trace = true, -- Enable verbose tracing
    },
    {
        type = "node2",
        name = "Launch NestJs",
        request = "launch",
        program = vim.fn.getcwd() .. "/src/main.ts",
        args = {},
        cwd = "${workspaceFolder}",
        runtimeArgs = { "--nolazy", "-r", "ts-node/register", "-r", "tsconfig-paths/register" },
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = { "<node_internals>/**" },
        env = {
            NODE_ENV = "development",
        },
        outFiles = { "${workspaceFolder}/dist/**/*.js" },
        trace = true, -- Enable verbose tracing
    },
    {
        type = "python",
        request = "launch",
        name = "Run with Arguments",
        program = function()
            return vim.fn.expand("%:p")
        end,
        pythonPath = "/usr/bin/python3.12",
        justMyCode = false, -- Debug all code, including libraries
        args = function()
            -- Prompt for input, defaulting to the last used arguments
            last_args = vim.fn.input("Enter arguments: ", last_args or "", "file")
            return vim.split(last_args, " ") -- Split into argument list
        end,
    },
}

return dap

