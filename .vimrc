" Disable compatibility with vi which can cause unexpected issues."
set nocompatible

let python_highlight_all=1
syntax on

" Display the docstrings for folded code:
let g:SimpylFold_docstring_preview=1

" Enable plugins and load plugin for the detected file type."
filetype plugin indent on

"Add relative numbers to each line on the left-hand side."
set number

" Highlight cursor line underneath the cursor horizontally."
set cursorline

"Highlight the words that we have searched for"
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

" Associate .ejs files with HTML syntax"
autocmd BufNewFile,BufRead *.ejs set filetype=html

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'ghifarit53/tokyonight-vim'
Plug 'joshdick/onedark.vim'
call plug#end()

set termguicolors

" Set colour scheme 
" colorscheme onedark " gruvbox  tokyonight 

" let g: airline_theme = 'tokyonight'

" Add the proper PEP 8 indentation to python files. This will ensure the following:
" -> consistent line spaces when you use enter tab
" -> line length doesn't go beyond 80 characters 
" -> stores files in a Unix format so that you don't get a bunch of conversion issues when checking into GitHub and/or sharing with others.
au BufNewFile,BufRead *.py
  \ set tabstop=4
  \ set softtabstop=4
  \ set shiftwidth=4
  \ set textwidth=79
  \ set expandtab
  \ set autoindent
  \ set fileformat=unix

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <silent> <space>  za

set splitbelow
set splitright

" Include different settings for different filetypes.
au BufNewFile,BufRead *.js, *.html, *.css
  \ set tabstop=2 |
  \ set softtabstop=2 |
  \ set shiftwidth=2 

" Flagging Unnecessary whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Make sure that VIM knows that you're working with UTF-8 encoding
set encoding=utf-8

set smartcase " Override ignorecase if search conains capitials
set scrolloff=3 " Keep 3 lines visible above/below cursor
set wildmenu  " Enhanced command completion
set laststatus=2 " Always show status line
