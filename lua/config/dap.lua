local dap = require("dap")
local dap_python = require("dap-python")

-- Ensure debugpy is set up correctly
dap_python.setup('python3')
vim.g.autoformat = false
-- Define Python debug configurations
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Run this file",
    program = function()
      return vim.fn.expand("%:p")
    end,
    pythonPath = "python3",
    justMyCode = false,            -- Debug all code, including libraries
  },
  {
    type = "python",
    request = "launch",
    name = "Run this file (Torch Dynamo Logs, Mamba)",
    program = function()
      return vim.fn.expand("%:p")
    end,
    pythonPath = "python3",
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
    pythonPath = "python3",
    justMyCode = false,            -- Debug all code, including libraries
    args = function()
        -- Prompt for input, defaulting to the last used arguments
        last_args = vim.fn.input("Enter arguments: ", last_args or "", "file")
        return vim.split(last_args, " ")  -- Split into argument list
    end
  }
}

return dap

