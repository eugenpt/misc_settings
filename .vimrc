
inoremap jk <ESC>
inoremap kj <ESC>

" https://superuser.com/a/1321520
nnoremap <C-j> :bprev<CR>                                                                            
nnoremap <C-k> :bnext<CR>

nnoremap <Leader>q :bnext<CR>:bd#<CR>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P


" https://stackoverflow.com/a/41814629/2624911
:map [[ ?{<CR>w99[{
:map ][ /}<CR>b99]}
:map ]] j0[[%/{<CR>
:map [] k$][%?}<CR>

nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" let mapleader=" "
map <Space> <Leader>


" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>:b
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
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
" It's useful to show the buffer number in the status line.
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P


function! EchoWarning(msg)
  echohl WarningMsg
  echo "Warning"
  echohl None
  echon ': ' a:msg
endfunction

" call EchoWarning('test')

function! CloseIfNotSaved()
    if &mod
        call EchoWarning('Unsaved changes !! ')
    else
        execute 'bnext'
        execute 'bd#'
        echo 'all OK'
    endif
endfunction

command! CloseIfNSaved call CloseIfNotSaved()
nmap <Leader>q :CloseIfNSaved<CR>

filetype plugin indent on
syntax on
set encoding=utf-8
" set clipboard=unnamedplus

" show existing tab with 4 spaces width
set tabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4
" " On pressing tab, insert 4 spaces
set expandtab

set autoindent
set smartindent
set hidden
set number

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'junegunn/fzf.vim'

Plug 'vim-python/python-syntax'

Plug 'sheerun/vim-polyglot'

Plug 'preservim/nerdcommenter'

call plug#end()

nnoremap <C-p> :GFiles<CR>

" set colorscheme=nirvana

