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

