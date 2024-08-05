-- ~/.config/nvim/lua/custom/open_at_line.lua
local M = {}

function M.open_at_line()
    -- Get the current line under the cursor
    local line = vim.api.nvim_get_current_line()
    -- Match the file path and line number in the stack trace
    local file_path, line_num, col_num = line:match("%s*at%s+[^%(]+%(([^:]+:[^:]+):(%d+):(%d+)%)")
    if file_path and line_num and col_num then
        -- Open the file at the specified line
        print("Opening " .. file_path)
        vim.cmd("tabnew " .. file_path)
        vim.cmd(line_num)
        vim.cmd("normal! zz")
    else
        print("Could not parse the stack trace line: " .. line)
    end
end

return M
