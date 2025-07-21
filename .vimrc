" Disable compatibility with vi which can cause unexpected issues.
set nocompatible
let python_highlight_all=1
syntax on
" Display the docstrings for folded code:
let g:SimpylFold_docstring_preview=1
" Enable plugins and load plugin for the detected file type.
filetype plugin indent on
"Add relative numbers to each line on the left-hand side.
set number
" Highlight cursor line underneath the cursor horizontally.
set cursorline
"Highlight the words that we have searched for
set hlsearch
"Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap
" Set shift width to 2 spaces.
set shiftwidth=2
" Set tab width to 2 columns
set tabstop=2
" Do not save backup file
set nobackup
" While searching through a file incrementally highlight matching characters
" as you type.
set incsearch
" Ignore capitial letters during search.
set ignorecase
" Show the mode you are on the last line.
set showmode
" Return to the last indent level rather than the start of a new line...
set autoindent
" Convert tabs to spaces, which is useful when the file moves to other systems
set expandtab
" Disable continuation of comments into the next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set nopaste
" Associate .ejs files with HTML syntax
autocmd BufNewFile,BufRead *.ejs set filetype=html

call plug#begin('~/.vim/plugged')
" Essential plugins (your existing ones)
Plug 'tpope/vim-sensible'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'ghifarit53/tokyonight-vim'
Plug 'joshdick/onedark.vim'

" Code Completion & IntelliSense
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP support for all languages
Plug 'jiangmiao/auto-pairs'                      " Auto-close brackets, quotes, etc.

" File Navigation & Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                          " Fuzzy finder
Plug 'preservim/nerdtree'                        " File explorer
Plug 'Xuyuanp/nerdtree-git-plugin'               " Git status in NERDTree

" Git Integration
Plug 'tpope/vim-fugitive'                        " Git commands in Vim
Plug 'airblade/vim-gitgutter'                    " Git diff in gutter

" HTML/CSS/JavaScript Specific
Plug 'mattn/emmet-vim'                           " HTML/CSS abbreviations
Plug 'alvan/vim-closetag'                        " Auto-close HTML tags
Plug 'hail2u/vim-css3-syntax'                    " Enhanced CSS3 syntax
Plug 'ap/vim-css-color'                          " Display CSS colors
Plug 'pangloss/vim-javascript'                   " Enhanced JavaScript syntax
Plug 'MaxMEllon/vim-jsx-pretty'                  " JSX syntax highlighting
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

" Python Specific
Plug 'vim-python/python-syntax'                 " Enhanced Python syntax
Plug 'tmhedberg/SimpylFold'                      " Better Python folding
Plug 'Vimjas/vim-python-pep8-indent'            " PEP8 indentation

" General Development
Plug 'tpope/vim-commentary'                      " Easy commenting
Plug 'tpope/vim-surround'                        " Surround text with quotes/brackets
Plug 'luochen1990/rainbow'                       " Rainbow parentheses
Plug 'Yggdroot/indentLine'                       " Show indentation lines

call plug#end()

set termguicolors
" Set colour scheme
colorscheme onedark " gruvbox  tokyonight
let g:airline_theme = 'tokyonight'

" Add the proper PEP 8 indentation to python files.
au BufNewFile,BufRead *.py
  \ set tabstop=2|
  \ set softtabstop=2|
  \ set shiftwidth=2|
  \ set textwidth=79 |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <silent> <space> za
set splitbelow
set splitright

" Include different settings for different filetypes.
au BufNewFile,BufRead *.js,*.html,*.css,*.jsx,*.ts,*.tsx
  \ set tabstop=2 |
  \ set softtabstop=2 |
  \ set shiftwidth=2
  \ set expandtab

" Define BadWhitespace highlight group
highlight BadWhiteSpace ctermbg=red guibg=red
" Flagging Unnecessary whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.js,*.html,*.css match BadWhitespace /\s\+$/

" Make sure that VIM knows that you're working with UTF-8 encoding
set encoding=utf-8
set smartcase " Override ignorecase if search contains capitals
set scrolloff=3 " Keep 3 lines visible above/below cursor
set wildmenu  " Enhanced command completion
set laststatus=2 " Always show status line

" ===== PLUGIN CONFIGURATIONS =====

" CoC.nvim configuration
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()

" Make <CR> auto-select the first completion item
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" NERDTree configuration
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" FZF configuration
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" Emmet configuration
let g:user_emmet_mode='n'    " only enable normal mode functions
let g:user_emmet_leader_key=','

" Auto-close tag configuration
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.jsx,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,javascript,jsx'

" ALE configuration (your existing linter)
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint', 'prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'python': ['autopep8', 'yapf'],
\}
let g:ale_fix_on_save = 1

" Prettier configuration
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" Rainbow parentheses
let g:rainbow_active = 1

" IndentLine configuration
let g:indentLine_enabled = 1
let g:indentLine_char = '│'

" Python syntax highlighting
let g:python_highlight_all = 1

" JavaScript syntax highlighting
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1

" Additional key mappings
" Quick save
nnoremap <leader>w :w<CR>
" Quick quit
nnoremap <leader>q :q<CR>
" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
