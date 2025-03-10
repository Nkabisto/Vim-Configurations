" Disable compatibility with vi which can cause unexpected issues."
set nocompatible

" Enable file detection. Vim will be able to try to detect the type of file in use."
filetype on

" Enable plugins and load plugin for the detected file type."
filetype plugin on

" Load an indent file for the detected file type."
filetype indent on

" Turn syntax highlighting on."
syntax on

"Add relative numbers to each line on the left-hand side."
set relativenumber

" Highlight cursor line underneath the cursor horizontally."
set cursorline

"Highlight the words that we have searched for"
set hlsearch

"Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" Set shif width to 2 spaces.
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

" Set colour scheme to desert
colorscheme desert

" Return to the last indent level rather than the start of a new line...
set autoindent

" Convert tabs to spaces, which is useful when the file moves to other systems
set expandtab

" Disable continuation of comments into the next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set nopaste 

" Enable syntax highlighting for JSDocs
let g:javascript_plugin_jsdoc = 1

"Enalbes some additional highlighting for NGDocs. Requires JSDoc plugin to be enabled as well.
let g:javascript_plugin_ngdoc = 1

" Enables syntax highlighting for Flow
let g:javascript_plugin_flow = 1

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'maxmellon/vim-jsx-pretty'
call plug#end()

" Enable auto completion as you type
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']

" Associate .handlebars and .hbs(another common extension for Handlebars files) with HTML to enable syntax 
" highlighting and other editor features.
au BufNewFile, BufRead *.handlebars set filetype=html
