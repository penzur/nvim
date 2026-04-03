return {
    { -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = "ibl",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
                highlight = {
                    "beep",
                },
            },
            scope = {
                enabled = false,
                show_start = false,
                show_end = false,
                highlight = "IblScope",
            },
        },
        config = function(_, opts)
            local hooks = require("ibl.hooks")
            -- create the highlight groups in the highlight setup hook
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "beep", { fg = "#222222" })
                vim.api.nvim_set_hl(0, "IblScope", { fg = "#333333" })
            end)

            require("ibl").setup(opts)
        end,
    },
}
