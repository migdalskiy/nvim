return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "python",
        "javascript",
        -- Add more languages as needed
      },
      highlight = { enable = true },
      indent = { enable = true },
      -- Add more Treesitter configurations here
    },
  },
}