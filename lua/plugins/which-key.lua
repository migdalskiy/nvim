return {
    {
        "folke/which-key.nvim",
        opts = function(_, opts)
            if opts.defaults then
                opts.defaults["<leader>p"] = { name = "+perforce" }
            end
            local wk = require("which-key")
            wk.register({
                p = {
                    name = "+perforce",
                    a = {
                        function()
                            local node = require("neo-tree.sources.manager").get_node()
                            if node then
                                local path = node.path
                                if node.type == "directory" then
                                    path = path .. "/..."
                                end
                                vim.fn.system('p4 add "' .. path .. '"')
                                print("Added to Perforce: " .. path)
                                require("neo-tree.sources.manager").refresh()
                            else
                                local file = vim.fn.expand("%:p")
                                vim.cmd("!p4 add " .. file)
                            end
                        end,
                        "Add to Perforce",
                    },
                    -- Add more Perforce-related mappings here
                },
            }, { prefix = "<leader>" })
            return opts
        end,
    },
}
