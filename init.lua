-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.guifont = "FiraCode Nerd Font Mono:h16"
vim.opt.clipboard = "unnamed,unnamedplus"
-- vim.g.lazyvim.config.options.disable_ligatures = "always"
vim.g.neovide_scroll_animation_length = 0
vim.g.scrolling_animation_enabled = false

vim.api.nvim_exec(
    [[
function! AnnotateFile()
  let l:filename = expand('%:p')
  let l:command = 'p4 annotate -u ' . l:filename
  execute 'vnew'
  execute 'term ' . l:command
endfunction

command! Annotate call AnnotateFile()
]],
    false
)

--require("auto-save").setup({})
