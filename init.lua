-- bytecode cache for lua modules
vim.loader.enable()

-- global
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- basic
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 3
vim.o.swapfile = false
vim.o.shortmess = 'atI'
vim.o.clipboard = 'unnamedplus'
vim.o.cursorline = true
vim.o.colorcolumn = '80'


-- indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

-- folding (treesitter-based)
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.fillchars:append({ fold = ' ' })

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.incsearch = true

-- visual
vim.o.termguicolors = true
vim.o.winborder = 'rounded'
vim.o.winwidth = 38
vim.o.signcolumn = 'yes'

-- keymaps
vim.keymap.set('n', ';', ':')
vim.keymap.set("n", "<C-c>", ":bd<CR>")
vim.keymap.set("n", "<C-j>", "2<CR>")
vim.keymap.set("n", "<C-k>", "2-")
vim.keymap.set("n", "<C-u>", "{")
vim.keymap.set("n", "<C-d>", "}")
vim.keymap.set("n", "<leader>bn", ":bn<CR>")
vim.keymap.set("n", "<leader>bp", ":bp<CR>")
vim.keymap.set("n", "<C-l>", ":tabNext<CR>")
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")

-- colorscheme (treesitter handles highlighting, no `syntax on`)
vim.pack.add { 'https://github.com/rebelot/kanagawa.nvim' }
vim.cmd.colorscheme('kanagawa-dragon')
-- highlights
local function on_color()
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
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'NONE', ctermbg = 'NONE', fg = '#bf5700' })
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = 'NONE', ctermbg = 'NONE', fg = '#bf5700' })

  -- diagnostic signs: transparent bg, keep their fg colors
  for _, sev in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local g = 'DiagnosticSign' .. sev
    local existing = vim.api.nvim_get_hl(0, { name = g, link = false })
    vim.api.nvim_set_hl(0, g, { bg = 'NONE', ctermbg = 'NONE', fg = existing.fg, ctermfg = existing.ctermfg })
  end

  -- others
  vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE', ctermbg = 'NONE', fg = '#666666' })
  vim.api.nvim_set_hl(0, 'LineNrAbove', { bg = 'NONE', ctermbg = 'NONE', fg = '#333333' })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { bg = 'NONE', ctermbg = 'NONE', fg = '#333333' })
  vim.api.nvim_set_hl(0, 'TablineFill', { bg = 'NONE', ctermbg = 'NONE' })
  vim.api.nvim_set_hl(0, 'Tabline', { bg = '#EEEEEE', ctermbg = 'NONE', fg = '#3333FF' })
  vim.api.nvim_set_hl(0, 'TablineSel', { bg = '#3333ff', ctermbg = 'NONE', fg = '#ffffff', bold = true })
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#223249' })
  -- vim.api.nvim_set_hl(0, 'Visual', { bg = '#00094F' })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'NONE' })
end
on_color()
vim.api.nvim_create_autocmd('ColorScheme', { callback = on_color })

-- completion
vim.o.completeopt = 'menu,menuone,noinsert,popup'
-- completion: arrows cycle, Enter confirms, Esc cancels
vim.keymap.set('i', '<Down>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })
vim.keymap.set('i', '<Up>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })
vim.keymap.set('i', '<CR>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
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
  vim.bo[bufnr].softtabstop = expand and sw or 0
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'make', 'gitconfig' },
  callback = function(a) set_indent(a.buf, 4, true) end,
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
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix [L]ist" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open diagnostic [Q]uickfix [D]iagnostics" })

-- quickfix
vim.keymap.set('n', '<leader>co', '<cmd>copen<cr>', { desc = 'open quickfix' })
vim.keymap.set('n', '<leader>cn', '<cmd>cnext<cr>', { desc = 'next quickfix' })
vim.keymap.set('n', '<leader>cp', '<cmd>cprev<cr>', { desc = 'prev quickfix' })
vim.keymap.set('n', '<leader>cc', '<cmd>cclose<cr>', { desc = 'close quickfix' })

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

-- lsp
vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }
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
                vim.lsp.util.apply_workspace_edit(action.edit, vim.lsp.get_client_by_id(cid).offset_encoding or 'utf-16')
              end
            end
          end
        end,
      })
    elseif client.name == 'ts_ls' then
      -- skip: let ESLint or Biome format
    elseif client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = buf, async = false, timeout_ms = 2000, id = client.id })
        end,
      })
    end
  end
})
-- biome only attaches when project has biome config
vim.lsp.config('biome', {
  root_markers = { 'biome.json', 'biome.jsonc' },
})

vim.lsp.enable({
  'gopls',
  'rust_analyzer',
  'lua_ls',
  'ts_ls',  -- typescript-language-server (npm i -g typescript typescript-language-server)
  'eslint', -- vscode-langservers-extracted (npm i -g vscode-langservers-extracted)
  'biome',  -- biome (npm i -g @biomejs/biome) - gated by biome.json
  'jsonls', -- json-language-server (from vscode-langservers-extracted)
  'html',   -- html-language-server (same package)
  'cssls',  -- css-language-server (same package)
})

-- auto-session
vim.o.sessionoptions = 'blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions'
vim.pack.add { 'https://github.com/rmagatti/auto-session' }
require('auto-session').setup {
  suppressed_dirs = { '~/', '~/Downloads', '/' },
}
vim.keymap.set('n', '<C-e>', '<cmd>AutoSession search<cr>', { desc = 'session search' })

-- mini.nvim (statusline + surround)
vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }
require('mini.statusline').setup {}
require('mini.surround').setup {}
require('mini.pairs').setup {}
require('mini.icons').setup {}
require('mini.icons').mock_nvim_web_devicons() -- so oil/telescope find icons

-- render markdown
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

-- neogit
vim.pack.add { 'https://github.com/neogitorg/neogit' }
vim.keymap.set("n", "<leader>gs", ":Neogit<CR>")

-- vim-visual-multi (Sublime/VSCode-style multi-cursor)
vim.pack.add { 'https://github.com/mg979/vim-visual-multi' }

-- oil.nvim (file explorer as buffer)
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
local oil_ready = false
vim.keymap.set('n', '<leader>n', function()
  if not oil_ready then
    require('oil').setup {
      columns = { 'icon' },
      view_options = { show_hidden = true },
    }
    oil_ready = true
  end
  require('oil').open()
end, { desc = 'open oil' })

-- telescope (lazy-loaded on first keymap use)
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
}
local telescope_ready = false
local function tel(picker)
  return function()
    if not telescope_ready then
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            i = { ['<esc>'] = actions.close },
            n = { ['<esc>'] = actions.close },
          },
        },
      }
      telescope_ready = true
    end
    require('telescope.builtin')[picker]()
  end
end
vim.keymap.set('n', '<C-p>', tel('find_files'), { desc = 'find files' })
vim.keymap.set('n', '<C-g>', tel('live_grep'), { desc = 'live grep' })
vim.keymap.set('n', '<C-b>', tel('buffers'), { desc = 'buffers' })
vim.keymap.set('n', '<leader>ht', tel('help_tags'), { desc = 'help tags' })
vim.keymap.set('n', '<C-f>', tel('lsp_document_symbols'), { desc = 'doc symbols' })

-- tree-sitter (main branch API)
vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

local ts_parsers = {
  'lua', 'go', 'rust', 'vim', 'vimdoc', 'bash', 'json', 'yaml',
  'markdown', 'markdown_inline',
  'typescript', 'tsx', 'javascript', 'jsdoc', 'html', 'css', 'graphql', 'prisma', 'toml',
}

-- alias jsonc filetype to json parser
vim.treesitter.language.register('json', 'jsonc')
require('nvim-treesitter').install(ts_parsers)

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_parsers,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
