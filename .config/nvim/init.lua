-- init.lua - Optimized Neovim Configuration

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath,
    "--branch=stable"
  })
end
vim.opt.rtp:prepend(lazypath)

-- Disable unused built-ins for faster startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

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
vim.opt.clipboard = "unnamedplus"
vim.g.python_highlight_all = 1

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
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Copy to system clipboard"})
vim.keymap.set('n', '<leader>p', '"+p', { desc = "Paste from system clipboard"})

-- Plugin Configuration
vim.g.ale_disable_lsp = 1

require("lazy").setup({
  -- UI
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      vim.cmd('colorscheme tokyonight-night')
    end
  },
  {
    'vim-airline/vim-airline',
    dependencies = {
      { 'vim-airline/vim-airline-themes', config = function()
          vim.g.airline_theme = 'dark'
        end
      }
    },
    event = "UIEnter"
  },

  -- File Tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeOpen" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
      { "<C-f>", "<cmd>NvimTreeFindFile<CR>", desc = "Find File in Tree" },
    },
    config = function()
      require('nvim-tree').setup({ view = { width = 30 } })
    end
  },

  -- LSP and Completion
  {
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    opts = {
      servers = {
        pyright = {},
        tsserver = {},
        html = {},
        cssls = {},
      },
    },
    config = function(_, opts)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for server, config in pairs(opts.servers) do
        config.capabilities = capabilities
        vim.lsp.config[server].setup(config)
      end
    end
  },

  -- Git
  {
    'tpope/vim-fugitive',
    cmd = { "Git", "Gstatus", "Gcommit" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" }
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<CR>', desc = "Find files" },
      { '<C-g>', '<cmd>Telescope live_grep<CR>', desc = "Live grep" },
      { '<leader>b', '<cmd>Telescope buffers<CR>', desc = "Buffers" },
    },
    config = function() end
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      local autopairs = require('nvim-autopairs')
      autopairs.setup({})
      autopairs.remove_rule("'")
      autopairs.remove_rule('"')
    end
  },

  -- ALE
  {
    'dense-analysis/ale',
    ft = { "python", "javascript", "typescript", "html", "css" },
    config = function()
      vim.g.ale_fixers = {
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
        javascript = { 'eslint', 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        python = { 'autopep8', 'yapf' },
      }
      vim.g.ale_fix_on_save = 1
      vim.g.ale_python_autopep8_options = '--max-line-length=88'
      vim.g.ale_python_yapf_options = '--style={based_on_style: pep8, column_limit: 88}'
    end
  },

  -- Emmet
  {
    'mattn/emmet-vim',
    ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      vim.g.user_emmet_mode = 'n'
      vim.g.user_emmet_leader_key = ','
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "python", "javascript", "html", "css", "lua", "vim" },
        highlight = { enable = true },
      })
    end
  },

  -- Python-specific
  { 'tmhedberg/SimpylFold', ft = "python" },
  { 'Vimjas/vim-python-pep8-indent', ft = "python" },

  -- Editing
  { 'tpope/vim-commentary', keys = { "gc", "gcc" } },
  { 'tpope/vim-surround', keys = { "cs", "ds", "ys" } },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = "BufReadPost",
    config = function()
      require('ibl').setup({})
    end
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = "BufReadPost",
    config = function() end
  },

  -- Base
  'tpope/vim-sensible',
}, {
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin", "tutor", "2html_plugin", "matchit", "matchparen",
      },
    },
  },
})

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.ejs",
  callback = function()
    vim.bo.filetype = "html"
  end,
})
