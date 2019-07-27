"Theme stuff
let g:solarized_termcolors=16
let g:solarized_termtrans=1
syntax enable
set background=dark
colorscheme solarized

"Read .nsh files with .sh syntax
au BufNewFile,BufRead *.nsh set syntax=sh

"Probably should be defined pretty early on
let mapleader = "\<Space>"

"Brandon told me this is cool
"let g:netrw_liststyle=3

"The internet told me this is cool
set nocompatible
set number
set smartcase "Search is case-insensitive when all is lowercase
set incsearch

"Set indenting
filetype plugin indent on
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set colorcolumn=80

"Tab/Buffer related stuff here
set hidden
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>p :bp<CR>
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

"Leader Key Mappings
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>o :edit 
nnoremap <Leader>s :split 
nnoremap <Leader>f :e .<CR>
nnoremap <Tab> <C-w><C-w>
nnoremap <Leader>i :set nonumber<CR>:set paste<CR>i
nnoremap <Leader>I :set number<CR>:set nopaste<CR>
nnoremap <silent> <Leader>d "_d
nnoremap <silent> <Leader>D "_D
nnoremap <silent> <Leader>c "_c
nnoremap <silent> <Leader>C "_C

"My Productivity <ESC> Sequences
imap <S-tab> <Esc>
imap fj <Esc>

"Other Productivity Sequences
nnoremap <CR> G
nnoremap Y y$

"Map Function keys to do cool shit
nnoremap <F1> :q<CR>
nnoremap <silent> <F6> :res +2<CR>
nnoremap <silent> <F7> :res -2<CR>
nnoremap <silent> <F9> :!clear;python3 %<CR>
nnoremap <silent> <F10> :!clear;bash %<CR>
nnoremap <F12> <C-z>

"Quick edit/load vimrc file
nnoremap <silent> <F3> :e $MYVIMRC<CR>
nnoremap <silent> <F4> :bd<CR>:so $MYVIMRC<CR>

"Better arrow keys for line wrapping in normal and visual modes
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"Fast arrow keys in normal mode and visual modes
nnoremap <Up> 10k
nnoremap <Down> 10j
nnoremap <Left> 10h
nnoremap <Right> 10l
vnoremap <Up> 10k
vnoremap <Down> 10j
vnoremap <Left> 10h
vnoremap <Right> 10l

"Because I'm stupid and can't type
:command! Q q

