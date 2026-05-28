local get_debugpy = require("util.debugpy_path").get_debugpy

return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    -- Ensure both debuggers are installed automatically by Mason
    ensure_installed = { "python", "codelldb" },

    handlers = {
      -- Your existing custom Python setup
      python = function()
        local path = get_debugpy()

        require("dap").adapters.python = {
          type = "executable",
          command = path,
          args = { "-m", "debugpy.adapter" },
        }
      end,

      -- The default handler catches codelldb (and any other adapter in ensure_installed)
      -- and sets up the standard configuration automatically.
      function(config)
        require("mason-nvim-dap").default_setup(config)
      end,
    },
  },
}

