return {
    "rmagatti/auto-session",
    lazy = false,

    keys = {
        { "<leader>ss", "<cmd>AutoSession search<CR>", desc = "[S]ession [s]earch" },
        { "<C-e>", "<cmd>AutoSession search<CR>", desc = "Session search" },
    },

    opts = {
        suppressed_dirs = { "~/", "~/projects", "~/downloads", "/" },
    },
}
