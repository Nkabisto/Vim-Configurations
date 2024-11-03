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





