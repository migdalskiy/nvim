local M = {}

function M.get_debugpy()
    if vim.env.DEBUGPY_PATH then
        return vim.env.DEBUGPY_PATH
    end

    local is_windows = package.config:sub(1, 1) == "\\"

    if not is_windows then
        return "/venv/bin/python"
    end

    return vim.fn.stdpath("data") .. "\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe"
end

return M
