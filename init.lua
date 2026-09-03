-- bytecode cache for lua modules
vim.loader.enable()

-- global
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- basic
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.swapfile = false
vim.opt.shortmess = 'atIF'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = false
vim.opt.colorcolumn = '80'
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = " " }
vim.opt.undofile = true

-- indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- folding (treesitter-based)
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.fillchars:append({ fold = ' ' })

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- visual
vim.opt.termguicolors = true
vim.opt.winborder = 'rounded'
vim.opt.winwidth = 38
vim.opt.signcolumn = 'yes'

-- keymaps
vim.keymap.set('n', ';', ':')
vim.keymap.set("n", "<C-c>", ":bd<CR>")
vim.keymap.set("n", "<C-j>", "2<CR>")
vim.keymap.set("n", "<C-k>", "2-")
vim.keymap.set("n", "<C-u>", "{")
vim.keymap.set("n", "<C-d>", "}")
vim.keymap.set("n", "<C-l>", ":bn<CR>")
vim.keymap.set("n", "<C-h>", ":bp<CR>")
-- vim.keymap.set("n", "<C-l>", ":tabNext<CR>")
-- vim.keymap.set("n", "<C-h>", ":tabprevious<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- diagnostics
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix [L]ist" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open diagnostic [Q]uickfix [D]iagnostics" })

-- quickfix
vim.keymap.set('n', '<leader>co', '<cmd>copen<cr>', { desc = 'open quickfix' })
vim.keymap.set('n', '<leader>cn', '<cmd>cnext<cr>', { desc = 'next quickfix' })
vim.keymap.set('n', '<leader>cp', '<cmd>cprev<cr>', { desc = 'prev quickfix' })
vim.keymap.set('n', '<leader>cc', '<cmd>cclose<cr>', { desc = 'close quickfix' })

-- mason
vim.keymap.set('n', '<leader>M', ':Mason<CR>', { desc = 'open mason' })

-- auto-session
vim.keymap.set('n', '<C-e>', '<cmd>AutoSession search<cr>', { desc = 'session search' })

-- highlights
local function on_color()
  -- if vim.g.colors_name == 'tokyonight-day' then return end
  for _, group in ipairs({
    'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder',
    'SignColumn', 'EndOfBuffer', 'WinSeparator',
    'TelescopeNormal',
    'TelescopePromptNormal',
    'TelescopeResultsNormal',
    'TelescopePreviewNormal',
  }) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
  end

  -- other telescope borders: dim
  for _, group in ipairs({
    'TelescopeBorder',
    'TelescopeResultsBorder', 'TelescopeResultsTitle',
    'TelescopePreviewBorder', 'TelescopePreviewTitle',
  }) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE', fg = '#aaaaaa' })
  end

  -- prompt (input) border: light blue
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'NONE', ctermbg = 'NONE', fg = '#AA66FF' })
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = 'NONE', ctermbg = 'NONE', fg = '#AA66FF' })

  -- diagnostic signs: transparent bg, keep their fg colors
  for _, sev in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local g = 'DiagnosticSign' .. sev
    local existing = vim.api.nvim_get_hl(0, { name = g, link = false })
    vim.api.nvim_set_hl(0, g, { bg = 'NONE', ctermbg = 'NONE', fg = existing.fg, ctermfg = existing.ctermfg })
  end

  -- others
  vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE', ctermbg = 'NONE', fg = '#777777' })
  vim.api.nvim_set_hl(0, 'LineNrAbove', { bg = 'NONE', ctermbg = 'NONE', fg = '#444444' })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { bg = 'NONE', ctermbg = 'NONE', fg = '#444444' })
  vim.api.nvim_set_hl(0, 'TablineFill', { bg = 'NONE', ctermbg = 'NONE' })
  vim.api.nvim_set_hl(0, 'Tabline', { bg = '#EEEEEE', ctermbg = 'NONE', fg = '#6666FF' })
  vim.api.nvim_set_hl(0, 'TablineSel', { bg = '#6666FF', ctermbg = 'NONE', fg = '#ffffff', bold = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'ColorColumn', { bg = 'NONE' })
end
vim.api.nvim_create_autocmd('ColorScheme', { callback = on_color })

-- completion
vim.opt.completeopt = 'menu,menuone,noinsert,popup'
-- completion: arrows cycle, Enter confirms, Esc cancels
vim.keymap.set('i', '<Down>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })
vim.keymap.set('i', '<Up>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })
vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end
  return require('mini.pairs').cr()
end, { expr = true })
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })
-- completion: manual trigger
vim.keymap.set('i', '<C-Space>', function()
  if vim.lsp.completion and vim.lsp.completion.get then
    vim.lsp.completion.get()
  end
end)
-- completion: retrigger LSP completion after edits when popup closed
vim.api.nvim_create_autocmd('TextChangedI', {
  callback = function()
    if vim.fn.pumvisible() == 1 then return end
    local col = vim.fn.col('.') - 1
    if col == 0 then return end
    local line = vim.api.nvim_get_current_line()
    local char = line:sub(col, col)
    -- retrigger on word chars (letters/digits/underscore)
    if char:match('[%w_]') and vim.lsp.completion and vim.lsp.completion.get then
      vim.lsp.completion.get()
    end
  end,
})

-- per-filetype indentation
local function set_indent(bufnr, sw, expand)
  vim.bo[bufnr].expandtab = expand
  vim.bo[bufnr].shiftwidth = sw
  vim.bo[bufnr].tabstop = sw
  vim.bo[bufnr].softtabstop = expand and sw or 4
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'make', 'gitconfig' },
  callback = function(a) set_indent(a.buf, 4, false) end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'rust', 'java', 'c', 'cpp' },
  callback = function(a) set_indent(a.buf, 4, true) end,
})

-- recognize bun runtime files
vim.filetype.add({
  extension = {
    mts = 'typescript',
    cts = 'typescript',
  },
  pattern = {
    ['bunfig%.toml'] = 'toml',
  },
})

-- diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN]  = '',
      [vim.diagnostic.severity.INFO]  = '',
      [vim.diagnostic.severity.HINT]  = '',
    },
  },
  virtual_text = { prefix = '' },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
})

require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = {        -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = {           -- Options related to messages in the cmdline window.
      height = 0.5    -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = {        -- Options related to dialog window.
      height = 0.5,   -- Maximum height.
    },
    msg = {           -- Options related to msg window.
      height = 0.5,   -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = {         -- Options related to message window.
      height = 1,     -- Maximum height.
    },
  },
})

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- colorschemes
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },

  -- mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require('mason').setup {}
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    config = function()
      require('mason-lspconfig').setup {
        automatic_enable = false,
        ensure_installed = {
          'gopls',
          'rust_analyzer',
          'lua_ls',
          'vtsls',
          'eslint',
          'biome',
          'jsonls',
          'html',
          'cssls',
          'emmet_language_server',
        },
      }
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          -- Enable inlay hints
          -- if client:supports_method('textDocument/inlayHint') then
          --   vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          -- end
          -- Basic LSP keymaps (optional)
          local buf = args.buf
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
          vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

          -- signature help: auto-trigger on ( and ,
          if client:supports_method('textDocument/signatureHelp') then
            vim.keymap.set('i', '(', function()
              vim.api.nvim_feedkeys('(', 'n', false)
              vim.defer_fn(function() vim.lsp.buf.signature_help() end, 50)
            end, { buffer = buf })
            vim.keymap.set('i', ',', function()
              vim.api.nvim_feedkeys(',', 'n', false)
              vim.defer_fn(function() vim.lsp.buf.signature_help() end, 50)
            end, { buffer = buf })
          end

          -- format on save (per-client logic)
          if client.name == 'eslint' then
            -- run ESLint fixAll on save (sync)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = buf,
              callback = function()
                ---@diagnostic disable-next-line: inject-field
                local params = vim.lsp.util.make_range_params(0, client.offset_encoding or 'utf-16')
                ---@diagnostic disable-next-line: inject-field
                params.context = { only = { 'source.fixAll.eslint' }, diagnostics = {} }
                local res = vim.lsp.buf_request_sync(buf, 'textDocument/codeAction', params, 2000)
                for cid, r in pairs(res or {}) do
                  for _, action in ipairs(r.result or {}) do
                    if action.edit then
                      vim.lsp.util.apply_workspace_edit(action.edit,
                        vim.lsp.get_client_by_id(cid).offset_encoding or 'utf-16')
                    end
                  end
                end
              end,
            })
          elseif client.name == 'biome' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = buf,
              callback = function()
                local fname = vim.api.nvim_buf_get_name(buf)
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

                local output = vim.fn.system({
                  'biome',
                  'check',
                  '--write',
                  '--stdin-file-path',
                  fname,
                }, table.concat(lines, '\n'))

                if #output > 0 then
                  local result = vim.split(output, '\n', { plain = true })
                  if result[#result] == '' then table.remove(result) end
                  vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
                end
              end,
            })
          elseif client.name == 'vtsls' then
            -- skip: let Biome format
          elseif client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = buf, async = false, timeout_ms = 2000, id = client.id })
              end,
            })
          end
        end,
      })
      -- biome only attaches when project has biome config
      vim.lsp.config('biome', {
        root_markers = { 'biome.json', 'biome.jsonc' },
      })

      vim.lsp.enable({
        'gopls',
        'rust_analyzer',
        'lua_ls',
        'vtsls',  -- vtsls (npm i -g @vtsls/language-server)
        'eslint', -- vscode-langservers-extracted (npm i -g vscode-langservers-extracted)
        'biome',  -- biome (npm i -g @biomejs/biome) - gated by biome.json
        'jsonls', -- json-language-server (from vscode-langservers-extracted)
        'html',   -- html-language-server (same package)
        'cssls',  -- css-language-server (same package)
        'emmet_language_server',
      })
    end,
  },

  -- auto-session
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      vim.opt.sessionoptions = 'blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions'
      require('auto-session').setup {
        suppressed_dirs = { '~/', '~/Downloads', '/' },
      }
    end,
  },

  -- mini.nvim
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require('mini.statusline').setup {}
      require('mini.surround').setup {}
      require('mini.pairs').setup {}
      require('mini.icons').setup {}
      require('mini.icons').mock_nvim_web_devicons() -- so oil/telescope find icons
    end,
  },

  -- render markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('render-markdown').setup {}
      for _, g in ipairs({ 'RenderMarkdownCode', 'RenderMarkdownCodeInline' }) do
        vim.api.nvim_set_hl(0, g, { bg = 'NONE', ctermbg = 'NONE', fg = 'NONE' })
      end
    end,
  },

  -- neogit
  {
    "neogitorg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "open neogit" },
    },
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('gitsigns').setup {}
    end,
  },

  -- vim-visual-multi
  { "mg979/vim-visual-multi", event = "BufRead" },

  -- oil
  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>n", function() require('oil').open() end, desc = "open oil" },
    },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        view_options = { show_hidden = true },
      }
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<C-p>",      function() require('telescope.builtin').find_files() end,           desc = "find files" },
      { "<C-g>",      function() require('telescope.builtin').live_grep() end,            desc = "live grep" },
      { "<leader>sb", function() require('telescope.builtin').buffers() end,              desc = "buffers" },
      { "<leader>sh", function() require('telescope.builtin').help_tags() end,            desc = "help tags" },
      { "<leader>sy", function() require('telescope.builtin').lsp_document_symbols() end, desc = "doc symbols" },
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            'node_modules/', '%.git/', 'dist/', 'build/', '%.lock',
            '%.min%.js', '%.min%.css', '__pycache__/', '%.pyc',
          },
          mappings = {
            i = { ['<esc>'] = actions.close,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
            },
            n = { ['<esc>'] = actions.close },
          },
        },
        pickers = {
          find_files = {
            find_command = { 'fd', '--type', 'f', '--hidden', '--follow', '--exclude', '.git' },
          },
        },
      }
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath('data') .. '/site',
      }

      local ts_filetypes = {
        'lua', 'go', 'rust', 'vim', 'help', 'sh', 'bash', 'json', 'jsonc', 'yaml',
        'markdown',
        'typescript', 'typescriptreact', 'javascript', 'javascriptreact',
        'html', 'css', 'graphql', 'prisma', 'toml',
      }

      -- register query-only languages (ecma, jsx) so their highlight queries
      -- can be loaded via inheritance (tsx inherits jsx, typescript inherits ecma)
      local function query_only_lang(lang, parser)
        local path = vim.api.nvim_get_runtime_file('parser/' .. parser .. '.so', false)[1]
        if path then
          vim.treesitter.language.add(lang, { path = path, symbol_name = parser })
        end
      end
      query_only_lang('ecma', 'typescript')
      query_only_lang('jsx', 'tsx')

      local ts_no_indent = { html = true, css = true }
      local function start_treesitter(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then return end

        if ts_no_indent[args.match] then
          vim.bo[args.buf].indentexpr = ''
        else
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = ts_filetypes,
        callback = start_treesitter,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local ft = vim.bo[buf].filetype
        if vim.tbl_contains(ts_filetypes, ft) then
          start_treesitter({ buf = buf, match = ft })
        end
      end
    end,
  },
  -- ghostty
  {
    dir = (vim.env.GHOSTTY_RESOURCES_DIR or "") .. "/../vim/vimfiles",
    lazy = false,
    name = "ghostty",
    cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil,
  },
})

vim.cmd.colorscheme('kanagawa-wave')
