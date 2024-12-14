-- Helper function to execute p4 commands
local function p4_cmd(cmd)
    return function()
        local file = vim.fn.expand("%:p")
        vim.fn.system(string.format('p4 %s "%s"', cmd, file))
        print(string.format("p4 %s %s", cmd, file))
    end
end

function TogglePyrightDiagnostics()
    local current_client = vim.lsp.get_active_clients({ name = "pyright" })[1]
    if current_client then
        if current_client.server_capabilities.diagnosticProvider then
            vim.diagnostic.disable(0)
            print("Pyright diagnostics disabled")
        else
            vim.diagnostic.enable(0)
            print("Pyright diagnostics enabled")
        end
    else
        print("Pyright is not attached to this buffer")
    end
end

function ChangeCwdToBufferDir()
    local buf_dir = vim.fn.expand("%:p:h")
    if buf_dir ~= "" then
        vim.cmd("cd " .. buf_dir)
        print("Changed directory to: " .. buf_dir)
    else
        print("No file path found for current buffer.")
    end
end

function TurnAutoFormatOff()
    vim.b.autoformat = false
    print("Autoformat disabled for this buffer")
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
        { "<leader>pe", p4_cmd("edit"), desc = "P4 Edit File" },
        { "<leader>pr", p4_cmd("revert"), desc = "P4 Revert File" },
        { "<leader>ct", TogglePyrightDiagnostics, desc = "Toggle Pyright Diagnistics" },
        { "<leader>pf", ChangeCwdToBufferDir, desc = "Change cwd to Buffer Dir" },
        { "<leader>cn", TurnAutoFormatOff, desc = "No Format-on-write" },
    },
}
