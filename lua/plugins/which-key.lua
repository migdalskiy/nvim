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


-- Function to print the full path of the current file
local function PrintFullPath()
  print(vim.fn.expand('%:p'))
end

-- Function to yank the full path to the system clipboard
local function YankFullPath()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)  -- Copy to system clipboard
  print('Path yanked: ' .. path)
end

-- Setup which-key mapping
--wk.setup({})

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Environment flags
local is_wsl = (vim.fn.has("unix") == 1) and vim.fn.readfile("/proc/version")[1]:lower():match("microsoft")
local is_ssh = os.getenv("SSH_CLIENT") ~= nil or os.getenv("SSH_TTY") ~= nil


local function reset_clipboard_provider()
  print('Using native clipboard provider')
  vim.g.clipboard = nil
end

-- 1. DEFINE STANDARD TERMINAL CLIPBOARD FUNCTION
-- We wrap this in a reusable function so we can apply it on startup
local function set_terminal_clipboard()
  if is_wsl and not is_ssh then
    print('WSL provider')
    vim.g.clipboard = {
      name = 'WslClipboard',
      copy = {
        ['+'] = 'powershell.exe -NoProfile -Command "Set-Clipboard -Raw"',
        ['*'] = 'powershell.exe -NoProfile -Command "Set-Clipboard -Raw"',
      },
      paste = {
        ['+'] = 'powershell.exe -NoProfile -Command "Get-Clipboard"',
        ['*'] = 'powershell.exe -NoProfile -Command "Get-Clipboard"',
      },
      cache_enabled = 0,
    }
  elseif is_ssh then
    print('SSH CONTEXT (Safe OSC 52)')
    vim.g.clipboard = {
      name = 'OSC 52-Safe',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('+'),
      },
      paste = {
        ['+'] = function() return {} end, -- Blocks hanging
        ['*'] = function() return {} end,
      },
    }
  elseif has("xclip") or has("xsel") or has("wl-clipboard") then
    reset_clipboard_provider()
  end
end



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
        { "<leader>pp", PrintFullPath, desc = "print the full path of the current file" },
        { "<leader>py", YankFullPath, desc = "yank the full path to the system clipboard" },
        { "<leader>pc", set_terminal_clipboard, desc = "Autodetect clipboard provider"},
        { "<leader>pz", reset_clipboard_provider, desc="Reset clipboard provider"}
    },
}
