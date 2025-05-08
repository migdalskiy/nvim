-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<F5>", function()
    require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
    require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
    require("dap").step_into()
end)
vim.keymap.set("n", "<S-F11>", function()
    require("dap").step_out()
end)
vim.keymap.set("n", "<F9>", function()
    require("dap").toggle_breakpoint()
end)

local dapui = require("dapui")
vim.keymap.set('n', '<leader>is', function() dapui.focus("stacks") end, { desc = "DAP UI Focus Stacks" })
vim.keymap.set('n', '<leader>iv', function() dapui.focus("scopes") end, { desc = "DAP UI Focus Variables (Scopes)" })
vim.keymap.set('n', '<leader>iw', function() dapui.focus("watches") end, { desc = "DAP UI Focus Watches" })
vim.keymap.set('n', '<leader>ir', function() dapui.focus("repl") end, { desc = "DAP UI Focus REPL" })
vim.keymap.set('n', '<leader>ic', function() dapui.focus("console") end, { desc = "DAP UI Focus Console" })
vim.keymap.set('n', '<leader>ib', function() dapui.focus("breakpoints") end, { desc = "DAP UI Focus Breakpoints" } )
vim.keymap.set('n', '<leader>iq', dapui.eval, { desc = "DAP UI Quick Eval" } )

vim.opt.textwidth = 0

vim.keymap.set("n", "<leader>it", ":lua vim.lsp.buf.format_inlay_hints()<CR>", { desc = "Convert inlay hints to text" })
-- for key, value in pairs(Snacks.dashboard) do if type(value) == "function" then print(key) end end
vim.keymap.set("n", "<leader>H", ":lua Snacks.dashboard.open()<CR>", {desc = "Open Snacks Dashboard" } )

-- Map Ctrl+Z to undo in insert mode
vim.api.nvim_set_keymap("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })

-- Map Ctrl+Y to redo in insert mode
vim.api.nvim_set_keymap("i", "<C-y>", "<C-o><C-r>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<C-Del>", "<C-o>dw", { noremap = true })

vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true, desc = "Delete word before cursor" })
vim.keymap.set("n", "<leader>dv", ":DapVirtualTextToggle<CR>", { desc = "Toggle DAP Virtual Text" })

local open_at_line = require("custom.open_at_line")
-- Map the function to a key combination, e.g., <leader>ol
vim.api.nvim_set_keymap(
    "n",
    "<leader>pl",
    ':lua require("custom.open_at_line").open_at_line()<CR>',
    { noremap = true, silent = true }
)

-- Yanky recommended mappings:
--vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
--vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
--vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
--vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

--vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
--vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
