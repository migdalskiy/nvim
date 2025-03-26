-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.dap")
vim.opt.guifont = "FiraCode Nerd Font Mono:h16"
vim.opt.clipboard = "unnamed,unnamedplus"
-- vim.g.lazyvim.config.options.disable_ligatures = "always"
vim.g.neovide_scroll_animation_length = 0
vim.g.scrolling_animation_enabled = false
vim.o.clipboard = "unnamedplus"
vim.g.autoformat = false

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("NoModWhenReadOnly", { clear = true }),
    callback = function()
        vim.opt_local.modifiable = not vim.opt_local.readonly:get()
        if vim.opt_local.modifiable then
            vim.notify(string.format("File %s is read-only", vim.fn.expand("%")), vim.log.levels.WARN)
        end
    end,
})

-- allow both dos and unix style line edings, autodetect and use file's actual line endings
vim.opt.fileformat = nil
vim.opt.fileformats = { "unix","dos" }
vim.opt.textwidth = 200

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.modifiable then
      vim.bo.fileformat = "unix"
    end
  end,
})

-- vim.api.nvim_exec(
--     [[
-- function! AnnotateFile()
--   let l:filename = expand('%:p')
--   let l:command = 'p4 annotate -u ' . l:filename
--   execute 'vnew'
--   execute 'term ' . l:command
-- endfunction
--
-- command! Annotate call AnnotateFile()
-- ]],
--     false
-- )
--
--require("auto-save").setup({})
