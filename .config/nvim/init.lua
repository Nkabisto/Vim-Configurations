-- init.lua - Optimized Neovim Configuration
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

-- Basic Settings (moved before plugins for faster UI)
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

-- Keymaps (set early so they're available)
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

-- Plugin Configuration with Lazy Loading
require("lazy").setup({
  -- Core UI (load immediately)
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
      {'vim-airline/vim-airline-themes', config = function()
        vim.g.airline_theme = 'dark'
      end}
    },
    event = "UIEnter" -- Load after UI is ready
  },

  -- File tree (load on command)
  { 
    'nvim-tree/nvim-tree.lua', 
    dependencies = {'nvim-tree/nvim-web-devicons'},
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeOpen" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
      { "<C-f>", "<cmd>NvimTreeFindFile<CR>", desc = "Find File in Tree" },
    },
    config = function()
      require('nvim-tree').setup({ view = { width = 30 } })
    end
  },

  -- LSP and completion (load on relevant events)
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
    config = function()
      local lspconfig = require('lspconfig')
      local cmp = require('cmp')
      
      cmp.setup({
        snippet = { 
          expand = function(args) 
            require('luasnip').lsp_expand(args.body) 
          end 
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources(
          { { name = 'nvim_lsp' }, { name = 'luasnip' } }, 
          { { name = 'buffer' }, { name = 'path' } }
        )
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Set up LSP servers only when files are opened
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python', 'javascript', 'typescript', 'html', 'css' },
        callback = function(ev)
          local ft = ev.match
          if ft == 'python' then
            lspconfig.pyright.setup({ capabilities = capabilities })
          elseif ft == 'javascript' or ft == 'typescript' then
            lspconfig.tsserver.setup({ capabilities = capabilities })
          elseif ft == 'html' then
            lspconfig.html.setup({ capabilities = capabilities })
          elseif ft == 'css' then
            lspconfig.cssls.setup({ capabilities = capabilities })
          end
        end
      })
    end
  },

  -- Git (load on relevant events)
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

  -- Tools (lazy loaded)
  { 
    'nvim-telescope/telescope.nvim', 
    dependencies = {'nvim-lua/plenary.nvim'},
    cmd = "Telescope",
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<CR>', desc = "Find files" },
      { '<C-g>', '<cmd>Telescope live_grep<CR>', desc = "Live grep" },
      { '<leader>b', '<cmd>Telescope buffers<CR>', desc = "Buffers" },
    },
    config = function() end -- config can be empty if just setting keymaps
  },

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

  { 
    'dense-analysis/ale',
    ft = { "python", "javascript", "typescript", "html", "css" },
    config = function()
      vim.g.ale_fixers = {
        ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
        javascript = {'eslint', 'prettier'},
        css = {'prettier'},
        html = {'prettier'},
        python = {'autopep8', 'yapf'},
      }
      vim.g.ale_fix_on_save = 1
      vim.g.ale_python_autopep8_options = '--max-line-length=88'
      vim.g.ale_python_yapf_options = '--style={based_on_style: pep8, column_limit: 88}'
    end 
  },

  { 
    'mattn/emmet-vim', 
    ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      vim.g.user_emmet_mode = 'n'
      vim.g.user_emmet_leader_key = ','
    end 
  },

  { 
    'nvim-treesitter/nvim-treesitter', 
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {"python", "javascript", "html", "css", "lua", "vim"},
        highlight = { enable = true },
      })
    end 
  },

  -- Language-specific (load only for relevant filetypes)
  { 
    'tmhedberg/SimpylFold', 
    ft = "python" 
  },

  { 
    'Vimjas/vim-python-pep8-indent', 
    ft = "python" 
  },

  -- Text objects and editing (load on first use)
  { 
    'tpope/vim-commentary', 
    keys = { "gc", "gcc" } 
  },

  { 
    'tpope/vim-surround', 
    keys = { "cs", "ds", "ys" } 
  },

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
    config = function()
      -- Optional: add specific configuration if needed
    end
  },

  -- Base plugins (load early)
  'tpope/vim-sensible',
}, {
  -- Lazy.nvim options for better performance
  checker = { enabled = false }, -- Don't check for updates on startup
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin",
        "tutor",
        "2html_plugin",
        "matchit",
        "matchparen",
      },
    },
  },
})

-- Autocommands (moved after plugins)
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
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
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

-- LSP keymaps (only set up when LSP attaches)
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

-- Syntax and filetype (at the end)
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')
