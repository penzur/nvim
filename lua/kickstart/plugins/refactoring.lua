return {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        local rf = require 'refactoring'
        rf.setup {}
        vim.keymap.set({ 'n', 'x' }, '<leader>rf', function()
            rf.select_refactor {}
        end)
    end,
}
