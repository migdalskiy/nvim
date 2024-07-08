--Claude 3.5
local inspect = require("inspect")

local function convert_inlay_hints_to_text()
    local current_line = vim.fn.line(".")
    local inlay_hints = vim.lsp.inlay_hint.get({
        bufnr = 0,
        range = {
            start = { line = current_line - 1, character = 0 },
            ["end"] = { line = current_line, character = 0 },
        },
    })

    if inlay_hints then
        local line_text = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
        print("Current buffer line: " .. line_text)
        for i = #inlay_hints, 1, -1 do
            local hint = inlay_hints[i]
            print(string.format("Hint %d: %s", i, inspect(hint)))
            line_text = line_text:sub(1, hint.position.character)
                .. hint.label
                .. line_text:sub(hint.position.character + 1)
        end
        vim.api.nvim_buf_set_lines(0, current_line - 1, current_line, false, { line_text })
    end
end

vim.keymap.set("n", "<leader>it", convert_inlay_hints_to_text, { desc = "Convert inlay hints to text" })

-- Assuming you have which-key set up
local wk = require("which-key")
wk.register({
    i = {
        t = { "<cmd>lua convert_inlay_hints_to_text()<CR>", "Convert inlay hints to text" },
    },
}, { prefix = "<leader>" })

--[[local function convert_inlay_hints_to_text()
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local hints = vim.lsp.inlay_hint.get(bufnr, line, line)

    if hints and #hints > 0 then
        local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
        for i = #hints, 1, -1 do
            local hint = hints[i]
            local text = hint.label
            if type(text) == "table" then
                text = table.concat(text)
            end
            current_line = current_line:sub(1, hint.position.character)
                .. text
                .. current_line:sub(hint.position.character + 1)
        end
        vim.api.nvim_buf_set_lines(bufnr, line, line + 1, false, { current_line })
        print("Inlay hints converted to text on the current line")
    else
        print("No inlay hints found on the current line")
    end
end

vim.api.nvim_set_keymap(
    "n",
    "<leader>it",
    "<cmd>lua convert_inlay_hints_to_text()<CR>",
    { noremap = true, silent = true }
)

local wk = require("which-key")
wk.register({
    i = {
        name = "Inlay Hints",
        t = { "<cmd>lua convert_inlay_hints_to_text()<CR>", "Convert to Text" },
    },
}, { prefix = "<leader>" })
--]]
--
--
--[[ Enable inlay hints for TypeScript
vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.with(vim.lsp.handlers.inlay_hint, {
    only_current_line = true,
    erase_extra_hints = false,
    highlight = "Comment",
})

-- Create a command to convert inlay hints to text
vim.api.nvim_create_user_command("ConvertInlayHints", function()
    vim.lsp.buf.format_inlay_hints({ only_current_line = true })
end, { desc = "Convert inlay hints to text" })

-- Create a key mapping to convert inlay hints to text
vim.keymap.set("n", "<leader>it", ":ConvertInlayHints<CR>", { desc = "Convert inlay hints to text" })

local wk = require("which-key")

wk.register({
    ["<leader>it"] = {
        name = "Convert Inlay Hints",
        function()
            vim.lsp.buf.format_inlay_hints({ only_current_line = true })
        end,
        desc = "Convert TypeScript inlay hints to text on current line",
    },
}, { prefix = "<leader>" })
--]]
