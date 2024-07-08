return {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
        opts.sections.lualine_c = {
            {
                "filename",
                path = 1, -- 1 for relative path, 2 for absolute path
                file_status = true,
                symbols = {
                    modified = "[+]",
                    readonly = "[-]",
                    unnamed = "[No Name]",
                },
            },
        }
    end,
}
