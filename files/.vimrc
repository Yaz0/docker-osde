" Don't try to be 'vi' compatible
set nocompatible
" Helps force plugins to load correctly when it is turned back on bellow
filetype off

" set the runtime path to include Vundle and initialize "
set rtp+=~/.vim/bundle/Vundle.vim

"Load plugins
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'itchyny/lightline.vim'
call vundle#end()

" For plugins to load correctly
filetype plugin indent on

" Turn on syntax higlighting
syntax on

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:>

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
" Clear search
map <leader><space> :let @/=''<cr> 

" Remap help key
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Formatting
map <leader>q gqip

" Visualize tabs and new lines
set listchars=tab:▸\ ,eol:¬
map <leader>l :set list!<CR>

" Color scehem (terminal)
set t_Co=256
set background=dark

set noshowmode

