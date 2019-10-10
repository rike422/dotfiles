set number
set ruler
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,eol:↲
set incsearch
set hlsearch
set nowrap
set showmatch
set whichwrap=h,l
set nowrapscan
set ignorecase
set smartcase
set hidden
set history=2000
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set helplang=en
map <leader>y "*y
map <leader>p "*p
set clipboard+=unnamed

set backspace=indent,eol,start
nnoremap <Space>w  :<C-u>w<CR>
nnoremap <Space>q  :<C-u>q<CR>
nnoremap <Space>Q  :<C-u>q!<CR>

nnoremap <Space>h  ^
nnoremap <Space>l  $

nnoremap k   gk
nnoremap j   gj
vnoremap k   gk
vnoremap j   gj
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j

nnoremap <Space>/  *<C-o>
nnoremap g<Space>/ g*<C-o>

nnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
nnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
vnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
vnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'

function! s:search_forward_p()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction


nnoremap <Space>o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>

nnoremap <silent> tt  :<C-u>tabe<CR>
nnoremap <C-p>  gT
nnoremap <C-n>  gt

nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

nnoremap Q gq


onoremap aa  a>
onoremap ia  i>
onoremap ar  a]
onoremap ir  i]
onoremap ad  a"
onoremap id  i"

inoremap jk  <Esc>

nnoremap gs  :<C-u>%s///g<Left><Left><Left>
vnoremap gs  :s///g<Left><Left><Left>

cnoremap <C-f>  <Right>
cnoremap <C-b>  <Left>
cnoremap <C-a>  <C-b>
cnoremap <C-e>  <C-e>
cnoremap <C-u> <C-e><C-u>
cnoremap <C-v> <C-f>a


""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

"if &runtimepath !~# '/dein.vim'
"  if !isdirectory(s:dein_repo_dir)
"    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
"  endif
"  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
"endif
"
"if dein#load_state(s:dein_dir)
"  call dein#begin(s:dein_dir)
"
"  let g:rc_dir    = expand('~/.vim/rc')
"  let s:toml      = g:rc_dir . '/dein.toml'
"  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
"
"  call dein#load_toml(s:toml,      {'lazy': 0})
"  call dein#load_toml(s:lazy_toml, {'lazy': 1})
"  call dein#end()
"  call dein#save_state()
"endif
"
"if dein#check_install()
"  call dein#install()
"endif

filetype plugin indent on
syntax on
set background=dark
