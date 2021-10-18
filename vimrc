" vim: fdm=marker
set nocompatible

" {{{ plug
call plug#begin('~/.vim/plugged')

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'lervag/vimtex'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'udalov/kotlin-vim'
Plug 'vimwiki/vimwiki'

call plug#end()
syntax on
" }}}

let g:syntastic_python_python_exec = '/bin/python3'
let g:gruvbox_italic=0
set modeline
set modelines=5
set backspace=indent,eol,start
set background=dark
set ruler
set hlsearch     "highlights all search
set breakindent  "smart wrap
set shiftwidth=2 "2 spaces for civilized people
set tabstop=2    "^
set noexpandtab
set nospell      "remove spell check for all files (added later)
set foldcolumn=0 "disgusting looking fold column"
set number       "add line number
set laststatus=2 "show status bar with file name
set linebreak
set display+=lastline
set list
set listchars=tab:│-
colorscheme gruvbox
highlight Normal ctermbg=NONE
autocmd BufRead,BufNewFile *.py set shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.java set shiftwidth=4 tabstop=4 expandtab
autocmd BufRead,BufNewFile *.txt set spell spelllang=en_us
autocmd BufRead,BufNewFile *.md set spell spelllang=en_us

function Format()
	if &ft =~ 'cpp'
		return
	endif
	call CocAction('format')
endfunction

nmap <silent> gf :call Format()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-rename)
nnoremap <silent> ff :call <SID>show_documentation()<CR>
inoremap <silent><expr> <c-k> coc#refresh()


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" {{{ Folding
nnoremap <Space> za
let anyfold_activate=1
set foldnestmax=1
set foldtext=getline(v:foldstart)
hi Folded term=bold cterm=NONE ctermfg=White
imap <C-F> <C-T>
function FoldText()
  let line = getline(v:foldstart)
  if &syntax ==# "marker"j
    let nofirstcharline = substitute(rawline, "[^\s] ", "", "")
    let removemarkerline = substitute(nofirstcharline, "{{{ *", "", "")
    " }}} <- only to match line before
    " super hacky, i know
    "
  endif
  let length = strlen(line)
  return "+ " . line . repeat(" ", winwidth(0)-length-2)
endfunction
set foldtext=FoldText()
hi Folded ctermfg=8 ctermbg=0
autocmd FileType go :set fdm=syntax
autocmd FileType javascript :set fdm=syntax

" }}}
" {{{ Indenting
vmap > >gv
vmap < <gv
" }}}
" {{{ FZF
nnoremap gg :Files<CR>
nnoremap <C-g> :Lines<CR>
nnoremap <C-n> :Buffers<CR>
" }}}
" {{{ Tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
" }}}
" {{{ Visual line moving
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
" }}}
" {{{ Alternative escape
inoremap jj <ESC>
" }}}
" {{{ Change from 2 spaces to 4 spaces (Python)
function SpaceConfigure()
  set sw=2 ts=2 noexpandtab
  retab!
  set sw=4 ts=4 expandtab
  retab
endfunction
nnoremap <f5> :call SpaceConfigure() <CR>
" }}}
" {{{ Indent Line (no longer used)
autocmd InsertEnter *.json setlocal concealcursor=
autocmd InsertLeave *.json setlocal concealcursor=inc
let g:indentLine_color_term = 238
let g:indentLine_concealcursor=''
" }}}
" {{{ copy register
nnoremap <f6> :%y+ <CR>
vnoremap <C-c> "+y
nnoremap <C-c> "+yy
nnoremap <C-p> "+p
" }}}
" {{{ Exec/compile commands
autocmd FileType cpp nnoremap <f7> :!g++ -DDEBUG -DTESTER -fsanitize=undefined -fsanitize=address -O2 -g % && ./a.out<CR>
autocmd FileType cpp nnoremap <f8> :!g++ -std=c++17 -DDEBUG -fsanitize=undefined -fsanitize=address -O2 -g % && ./a.out<CR>
autocmd FileType cpp nnoremap <f9> :!cf-tool test <CR>
autocmd FileType python nnoremap <f7> :!python3 % <CR>
autocmd FileType javascript noremap <f7> :!npx eslint % <CR>
autocmd FileType go noremap <f7> :!go run % <CR>
autocmd FileType tex noremap <f7> :!pdflatex % <CR>
autocmd BufRead,BufNewFile *.pug noremap <f7> :!pug % <CR>
autocmd BufRead,BufNewFile *.md noremap <f7> :Dispatch mdf %<CR>
autocmd BufRead,BufNewFile *.md noremap <f8> :exec("Dispatch zathura ." . bufname("%") . ".pdf") <CR>
highlight LineNr ctermfg=238
" }}}
" {{{ Trailing Whitespace phobia
function CleanWhitespace()
  %s/\s\+$//e
endfunction
highlight ExtraWhitespace ctermbg=red
let ew=matchadd('ExtraWhitespace', '\s\+\%#\@<!$', -100)
nnoremap <f4> :call CleanWhitespace() <CR>
" }}}
" {{{ Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
" }}}
" {{{ Latex
let g:vimtex_view_general_viewer="zathura"
let g:tex_conceal = ""
au FileType tex :NoMatchParen
" }}}
" {{{ VoidLinux
autocmd! BufNewFile,BufRead,BufEnter template set noexpandtab
" }}}
" {{{ WordCount
function! WC()
    let filename = expand("%")
    let cmd = "detex " . filename . " | wc -w | tr -d '\n'"
    let result = system(cmd)
    echo result . " words"
endfunction
command WC call WC()"
" }}}
" {{{ SimpylFold
let g:SimpylFold_fold_docstring = 0
let g:SimpylFold_fold_import = 0
" }}}
" {{{ Easy Align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}

noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
nnoremap gR *:%s///gc<left><left><left>
