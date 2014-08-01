set number " show line numbers 
set ts=79  " 79 chars wide
set nowrap " don't wrap on load
set colorcolumn=80
highlight ColorColumn ctermbg=233
set ts=4
set sw=4
set expandtab
set foldmethod=marker
set encoding=utf-8

set nocompatible               " be iMproved
filetype off                   " required!
let g:Powerline_symbols = 'fancy'
set laststatus=2 

" Automatically reload vimrc
autocmd! bufwritepost .vimrc source %

" Better? copy paste
set pastetoggle=<F2>

" leader key
let mapleader = ","

" move code blocks
vnoremap < <gv 
vnoremap > >gv 

" Quicksave
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C> :update<CR>
inoremap <C-Z> <C-O> :update<CR>

set t_Co=256
" ex command for toggling hex mode - define mapping if desired
"command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

syntax enable
if has('gui_running')
    colorscheme solarized
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11
else
    set clipboard=unamed
endif
set background=dark

" Powerline magic
set rtp+=~/src/powerline/powerline/bindings/vim

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" original repos on github
Bundle 'tpope/vim-pathogen'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'rkulla/pydiction'
Bundle 'klen/python-mode'
Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-scripts/tlib'
Bundle 'Lokaltog/vim-distinguished'
Bundle 'davidhalter/jedi-vim'
Bundle 'puppetlabs/puppet-syntax-vim'
Bundle 'benmills/vimux'
Bundle 'kien/ctrlp.vim'
Bundle 'msanders/snipmate.vim'
Bundle 'godlygeek/tabular'
Bundle 'scrooloose/syntastic'

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed.


" Switch between windows/buffers
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" PyDiction
let g:pydiction_location = '/Users/gcroker/Dropbox/env/vim/bundle/pydiction/complete-dict'

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()


nnoremap j gj
nnoremap k gk
