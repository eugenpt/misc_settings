
inoremap jk <ESC>
inoremap kj <ESC>

" https://superuser.com/a/1321520
nnoremap <C-j> :bprev<CR>                                                                            
nnoremap <C-k> :bnext<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

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
nnoremap <Leader>l :ls<CR>:b<Space>
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
noremap <Leader>0 :10b<CR>
" It's useful to show the buffer number in the status line.
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" move between tabs as in Vimium (!) =)
"  but first remap man to M
nnoremap M K
nnoremap J gT
nnoremap K gt
" and also - :close shortcut
nnoremap <Leader>c :close<CR>

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

Plug 'easymotion/vim-easymotion'
Plug 'morhetz/gruvbox'

" https://habr.com/ru/post/486948/
Plug 'itchyny/vim-gitbranch'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'

Plug 'scrooloose/nerdcommenter'


Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

Plug 'itchyny/lightline.vim'



" Проверка Синтаксиса
Plug 'scrooloose/syntastic' 
" Плагин автозавершения
"Plug 'Valloric/YouCompleteMe'
" Поддержка Python
"Plug 'klen/python-mode


call plug#end()

colorscheme gruvbox
set background=dark

nnoremap <C-p> :GFiles<CR>

" set colorscheme=nirvana

let g:NERDSpaceDelims = 1


map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>w <Plug>(easymotion-w)
map <Leader>b <Plug>(easymotion-b)

map <Leader>W <Plug>(easymotion-W)
map <Leader>B <Plug>(easymotion-B)

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

nmap s <Plug>(easymotion-overwin-f2)

" imap <C-w> <Esc><C-w>

" Делаем линейку для отображения на какой мы строке и сколько расстояния до
" других строк в **NeoVim**
set number
set ruler

" В нормальном режиме Ctrl+n вызывает :NERDTree
nmap <C-n> :NERDTreeToggle<CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

" set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" Линия статуса: конфигурация
set noshowmode " Табличка --INSERT-- больше не выводится на экран
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'filename': '%n:%t'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" Always show search result in the middle of the screen
nmap * *zz
nmap n nzz
nmap N Nzz


" Yep, no backspace on my watch
imap <Backspace> <nop>

" highlight search results + while typing
set hls
set incsearch




