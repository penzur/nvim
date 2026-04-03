-- INIT
--
---@diagnostic disable: missing-fields
-- global
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- options
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"

-- vim.opt.guicursor = "n-v-i-c:block-Cursor"
-- vim.opt.guicursor = {
--   'n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
--   'i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
--   'r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100'
-- }

vim.opt.cursorline = false
vim.opt.scrolloff = 10
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false
vim.opt.shortmess = "atI"

vim.opt.winborder = "rounded"
vim.opt.winwidth = 38 -- Set a minimum width, adjust as needed

-- mappings
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<C-c>", ":bd<CR>")
-- vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("n", "<C-u>", "{")
vim.keymap.set("n", "<C-d>", "}")
vim.keymap.set("n", "<leader>n", ":Oil<CR>")
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>")
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>")
vim.keymap.set("n", "<C-j>", "2<CR>")
vim.keymap.set("n", "<C-k>", "2-")
vim.keymap.set("n", "<M-j>", "3<CR>")
vim.keymap.set("n", "<M-k>", "3-")
vim.keymap.set("v", "<C-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gs", ":Neogit<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix [L]ist" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open diagnostic [Q]uickfix [D]iagnostics" })
-- pakshit
vim.keymap.set("n", '"', 'vi"')
vim.keymap.set("n", "'", "vi'")

-- enable inlay hint if available
-- if vim.lsp.inlay_hint then
--   vim.lsp.inlay_hint.enable(true, { 0 })
-- end

vim.keymap.set("n", "<C-t>", function()
	local tab = string.char(9)
	local cmd = "tmux list-windows -a -F '#{session_name}:#{window_index}"
		.. tab
		.. "#{window_name} - #{pane_current_path}' | sed \"s|$HOME|~|g\" | fzf-tmux -h --reverse --delimiter='"
		.. tab
		.. "' --with-nth=2 2>/dev/null"
	local selected = vim.fn.system(cmd)
	selected = selected:gsub("%s+$", "")
	if selected ~= "" then
		local target = selected:match("^([^\t]+)")
		if target then
			vim.fn.system("tmux switch-client -t " .. vim.fn.shellescape(target))
		end
	end
end, { noremap = true, silent = true, desc = "Switch tmux window" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- <escape> should close netrw, neogitstatus buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "netrw", "NeogitStatus", "oil" }, -- specify file types
	callback = function()
		local opts = { noremap = true, silent = true }
		local bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<escape>", ":bd!<CR>", opts)
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	-- {
	--   "folke/which-key.nvim",
	--   event = "VimEnter", -- Sets the loading event to 'VimEnter'
	--   opts = {
	--     icons = {
	--       -- set icon mappings to true if you have a Nerd Font
	--       mappings = vim.g.have_nerd_font,
	--       -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
	--       -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
	--       keys = vim.g.have_nerd_font and {} or {
	--         Up = "<Up> ",
	--         Down = "<Down> ",
	--         Left = "<Left> ",
	--         Right = "<Right> ",
	--         C = "<C-…> ",
	--         M = "<M-…> ",
	--         D = "<D-…> ",
	--         S = "<S-…> ",
	--         CR = "<CR> ",
	--         Esc = "<Esc> ",
	--         ScrollWheelDown = "<ScrollWheelDown> ",
	--         ScrollWheelUp = "<ScrollWheelUp> ",
	--         NL = "<NL> ",
	--         BS = "<BS> ",
	--         Space = "<Space> ",
	--         Tab = "<Tab> ",
	--         F1 = "<F1>",
	--         F2 = "<F2>",
	--         F3 = "<F3>",
	--         F4 = "<F4>",
	--         F5 = "<F5>",
	--         F6 = "<F6>",
	--         F7 = "<F7>",
	--         F8 = "<F8>",
	--         F9 = "<F9>",
	--         F10 = "<F10>",
	--         F11 = "<F11>",
	--         F12 = "<F12>",
	--       },
	--     },
	--
	--     -- Document existing key chains
	--     spec = {
	--       -- { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
	--       -- { "<leader>d", group = "[D]ocument" },
	--       -- { "<leader>r", group = "[R]ename" },
	--       -- { "<leader>s", group = "[S]earch" },
	--       -- { "<leader>w", group = "[W]orkspace" },
	--       -- { "<leader>t", group = "[T]oggle" },
	--       -- { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
	--     },
	--   },
	-- },

	-- KICKSTART
	require("kickstart.plugins.lsp"),
	require("kickstart.plugins.conform"),
	require("kickstart.plugins.mini"),
	require("kickstart.plugins.cmp"),
	-- require("kickstart.plugins.lint"),
	require("kickstart.plugins.ts"),
	-- require("kickstart.plugins.indent_line"),
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.autosession"),
	require("kickstart.plugins.refactoring"),
	require("kickstart.plugins.neogit"),
	require("kickstart.plugins.ai"),
	require("kickstart.plugins.telescope"),
	require("kickstart.plugins.gitsigns"),
	require("kickstart.plugins.rename"),
	-- KICKSTART

	-- THEMES
	{ "Mofiqul/vscode.nvim" },
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
	{ "rebelot/kanagawa.nvim" },
	{
		"projekt0n/github-nvim-theme",

		priority = 1000,
		config = function()
			vim.cmd.colorscheme("kanagawa-dragon")
			-- Basic UI elements
			-- vim.cmd.hi("Comment gui=none cterm=none")
			-- vim.cmd.hi("Visual guibg=darkblue cterm=none ctermbg=white ctermfg=black guibg=yellow")
			-- vim.cmd.hi("Visual guibg=darkblue cterm=none ctermbg=white ctermfg=black guibg=darkblue")
			vim.cmd.hi("Visual cterm=none gui=none")
			vim.cmd.hi("LineNr guifg=#666665 guibg=none ctermbg=none")
			vim.cmd.hi("CursorLineNr guifg=#FF9998 guibg=none ctermbg=none gui=bold")
			vim.cmd.hi("CursorLine guibg=none ctermbg=none")
			-- vim.cmd.hi("Cursor guibg=darkblue ctermbg=none")
			vim.cmd.hi("Normal guibg=none guifg=none ctermbg=none")
			vim.cmd.hi("ColorColumn guibg=#ff2222")
			vim.cmd.hi("clear StatusLine")
			vim.cmd.hi("clear SignColumn")

			-- Telescope specific highlights
			vim.cmd.hi("TelescopePromptBorder guibg=none ctermbg=none")
			-- vim.cmd.hi("NormalFloat guibg=#222222")
			vim.cmd.hi("clear FloatTitle")
			vim.cmd.hi("clear TelescopeBorder")
			vim.cmd.hi("clear TelescopeNormal")
			vim.cmd.hi("clear TelescopePromptNormal")
			vim.cmd.hi("clear TelescopePromptBorder")
			vim.cmd.hi("clear TelescopePromptTitle")
			--
			-- Git signs highlights
			vim.cmd.hi("GitSignsAdd guibg=none ctermbg=none")
			vim.cmd.hi("GitSignsChange guibg=none ctermbg=none")
			vim.cmd.hi("GitSignsDelete guibg=none ctermbg=none")
			vim.cmd.hi("DiagnosticSignError guibg=none ctermbg=none")
			vim.cmd.hi("DiagnosticSignHint guibg=none ctermbg=none")
			vim.cmd.hi("DiagnosticSignInfo guibg=none ctermbg=none")
			vim.cmd.hi("DiagnosticSignOk guibg=none ctermbg=none")
			vim.cmd.hi("DiagnosticSignWarn guibg=none ctermbg=none")

			vim.cmd.hi("clear NormalFloat")
			vim.cmd.hi("clear FloatBorder")
		end,
	},
	{
		"folke/tokyonight.nvim",
	},
	-- THEMES
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "mg979/vim-visual-multi" },
	-- { "github/copilot.vim" },
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			win_options = {
				signcolumn = "yes:2",
			},
		},
		-- Optional dependencies
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	{
		"refractalize/oil-git-status.nvim",

		dependencies = {
			"stevearc/oil.nvim",
		},

		config = true,
	},
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- Define diagnostic icons
-- local signs = {
--   Error = "", -- nf-fa-times_circle / or 
--   Warn  = "", -- nf-fa-exclamation_triangle / or 
--   Hint  = "", -- nf-fa-lightbulb_o / or 
--   Info  = "", -- nf-fa-info_circle / or 
-- }

-- Apply the icons
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- end

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		-- Optional: Apply highlighting groups
		linehl = {},
		numhl = {},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
