vim.api.nvim_create_user_command("OpenError", function()
    local line = vim.fn.getline(".")
    local file, lnum, col = line:match("([^:]+):(%d+):(%d+)")
    if file and lnum and col then
        -- Open the file first
        vim.cmd("edit " .. file)
        -- Then move to the specific line and column
        vim.cmd("normal! " .. lnum .. "G" .. col .. "|")
        -- vim.cmd(string.format("e +%s %s", lnum, file))
        -- vim.cmd(string.format("normal! %s|", col))
    else
        print("Couldn't parse error line")
    end
end, {})

-- Assign a keybinding to OpenError
vim.keymap.set("n", "<leader>y", "<cmd>OpenError<cr>", { desc = "Open Error Location" })

-- Optionally, register the keybinding with which-key.nvim
local which_key = require("which-key")
which_key.register({
    y = { "<cmd>OpenError<cr>", "Open Error Location" },
}, { prefix = "<leader>" })
