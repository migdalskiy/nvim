return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
        opts.filesystem = opts.filesystem or {}
        opts.filesystem.filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        }
        opts.window = opts.window or {}
        opts.window.mappings = opts.window.mappings or {}
        opts.window.mappings["J"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
                vim.cmd("cd " .. node.path)
                vim.notify("Changed directory to: " .. node.path, vim.log.levels.INFO)
            end
        end
        return opts
    end,
}
