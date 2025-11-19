local get_debugpy = require("util.debugpy_path").get_debugpy

return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    handlers = {
      python = function()
        local path = get_debugpy()

        require("dap").adapters.python = {
          type = "executable",
          command = path,
          args = { "-m", "debugpy.adapter" },
        }
      end,
    },
  },
}

