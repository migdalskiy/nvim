-- Helper function to execute p4 commands
local function p4_cmd(cmd)
    return function()
        local file = vim.fn.expand("%:p")
        vim.fn.system(string.format('p4 %s "%s"', cmd, file))
        print(string.format("p4 %s %s", cmd, file))
    end
end

-- Setup which-key mapping
--wk.setup({})

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
        { "<leader>p", group = "Perforce" }, -- group
        {
            "<leader>pb",
            function()
                require("which-key").show({ global = false })
                local file = vim.fn.expand("%:p")
                vim.fn.system(string.format('p4 add "%s"', file))
                print(string.format("p4 add %s", file))
            end,
            desc = "Perforce Add v1",
        },
        { "<leader>pa", p4_cmd("add"), desc = "P4 Add File" },
        { "<leader>pb", p4_cmd("edit"), desc = "P4 Edit File" },
        { "<leader>pr", p4_cmd("revert"), desc = "P4 Revert File" },
    },
}
