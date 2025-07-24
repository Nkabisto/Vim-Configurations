-- init.lua - Optimized and Clean Neovim Configuration

-- Basic Settings
vim.opt.compatible = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.backup = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 3
vim.opt.wildmenu = true
vim.opt.laststatus = 2
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.encoding = 'utf-8'

vim.opt.paste = false

vim.g.python_highlight_all = 1

vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- Plugin Manager Setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'tpope/vim-sensible',

  { 'dense-analysis/ale', config = function()
    vim.g.ale_fixers = {
      ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
      javascript = {'eslint', 'prettier'},
      css = {'prettier'},
      html = {'prettier'},
      python = {'autopep8', 'yapf'},
    }
    vim.g.ale_fix_on_save = 1
  end },

  { 'vim-airline/vim-airline', dependencies = {'vim-airline/vim-airline-themes'}, config = function()
    vim.g.airline_theme = 'dark'
  end },

  { 'folke/tokyonight.nvim', priority = 1000, config = function()
    vim.cmd('colorscheme tokyonight-night')
  end },

  { 'neovim/nvim-lspconfig', dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }, config = function()
    local lspconfig = require('lspconfig')
    local cmp = require('cmp')
    cmp.setup({
      snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } }, { { name = 'buffer' }, { name = 'path' } })
    })
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lspconfig.pyright.setup({ capabilities = capabilities })
--    lspconfig.tsserver = nil -- Optional, to avoid deprecated warning
    lspconfig.ts_ls.setup({ capabilities = capabilities })
    lspconfig.html.setup({ capabilities = capabilities })
    lspconfig.cssls.setup({ capabilities = capabilities })
  end },

  { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup({}) end },

  { 'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}, config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-p>', builtin.find_files, {})
    vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>b', builtin.buffers, {})
  end },

  { 'nvim-tree/nvim-tree.lua', dependencies = {'nvim-tree/nvim-web-devicons'}, config = function()
    require('nvim-tree').setup({ view = { width = 30 } })
    vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {})
    vim.keymap.set('n', '<C-f>', ':NvimTreeFindFile<CR>', {})
  end },

  'tpope/vim-fugitive',

  { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end },

  { 'mattn/emmet-vim', config = function()
    vim.g.user_emmet_mode = 'n'
    vim.g.user_emmet_leader_key = ','
  end },

  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {"python", "javascript", "html", "css", "lua", "vim"},
      highlight = { enable = true },
    })
  end },

  'tmhedberg/SimpylFold',
  'Vimjas/vim-python-pep8-indent',
  'tpope/vim-commentary',
  'tpope/vim-surround',

  { 'lukas-reineke/indent-blankline.nvim', main= 'ibl', config = function()
    require('ibl').setup({})
  end },

  'HiPhish/rainbow-delimiters.nvim',
})

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({"c", "r", "o"})
  end,
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.ejs",
  callback = function()
    vim.bo.filetype = "html"
  end,
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.py",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.textwidth = 79
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.fileformat = "unix"
  end,
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.js", "*.html", "*.css", "*.jsx", "*.ts", "*.tsx"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.cmd [[ highlight BadWhitespace ctermbg=red guibg=red ]]
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.py", "*.pyw", "*.c", "*.h", "*.js", "*.html", "*.css"},
  callback = function()
    vim.cmd [[ match BadWhitespace /\s\+$/ ]]
  end,
})

-- Keymaps
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<C-J>', '<C-W><C-J>')
vim.keymap.set('n', '<C-K>', '<C-W><C-K>')
vim.keymap.set('n', '<C-L>', '<C-W><C-L>')
vim.keymap.set('n', '<C-H>', '<C-W><C-H>')
vim.keymap.set('n', '<F2>', ':set invpaste paste?<CR>')
vim.keymap.set('n', '<space>', 'za')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})
