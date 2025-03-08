return {
  "hedyhli/outline.nvim",
  keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
  cmd = "Outline",
  opts = {
    symbols = {
      icons = {},
      filter = vim.deepcopy(LazyVim.config.kind_filter),
    },
    keymaps = {
      up_and_jump = "<up>",
      down_and_jump = "<down>",
    },
  },
}
