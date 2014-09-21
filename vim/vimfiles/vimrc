" Author: Trent Nelson <trent dot nelson at continuum dot io>
"----------------------------------------------------------------------------"
" top-level initialisation
"----------------------------------------------------------------------------"
set nocompatible

let s:basedir=expand('<sfile>:p:h')

set runtimepath+=s:basedir
set tags=./tags;

if version >= 703
    set autochdir
endif

" Silence annoying CSApprox GUI warnings.
let g:CSApprox_verbose_level = 0

set smartcase

" http://nvie.com/posts/how-i-boosted-my-vim/
let mapleader=","
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
set hidden
"nnoremap ; :

" Format current paragraph or selection.
vmap Q gq
nmap Q gqap
" Step down wrapped multilines.
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Sudo force for save.
cmap w!! w !sudo tee % >/dev/null

let g:is_unix=0
let g:is_cygwin=0
let g:is_windows=0
let g:is_darwin=0
let g:is_bash=1
let g:rundir=""
let g:appname='vim'
let g:viminfo_file='viminfo'
if has("unix")
    let g:is_unix=1
endif
if has("win32unix")
    let g:appname='vim.cygwin'
    let g:is_cygwin=1
    let g:viminfo_file='viminfo.cygwin'
elseif has("win32")
    let g:appname='vim.win32'
    source $VIMRUNTIME/mswin.vim
    let g:is_windows=1
endif

if has("gui_running")
    if has("gui_macvim")
        let g:appname='mac' . g:appname
    else
        let g:appname='g' . g:appname
    endif
endif

let g:rundir='~/.vim/run/'
let g:hostconfdir = '~/.vim/hosts/'
if g:is_windows || g:is_cygwin
    let g:hostname = tolower($COMPUTERNAME)
    let g:username = tolower($USERNAME)
else
    let g:hostname = tolower(split(system('hostname'), '\n')[0])
    let g:username = tolower(split(system('whoami'), '\n')[0])
    if system('uname') =~ "Darwin"
        let g:is_darwin=1
    endif
endif

let g:hostconfstage = 'early'
let g:hostconfdir = expand(g:hostconfdir)
let g:hostconf = g:hostconfdir . g:hostname
if filereadable(g:hostconf)
    exec 'source' g:hostconf
endif

let g:rundir .= g:username . '_' . g:hostname
let g:rundir=expand(g:rundir)

if !isdirectory(g:rundir)
    call mkdir(g:rundir, 'p', 0700)
endif

let g:yankring_history_dir = g:rundir . '/yankring'
if !isdirectory(g:yankring_history_dir)
    call mkdir(g:yankring_history_dir, 'p', 0700)
endif

set backup
set writebackup
let &backupdir=g:rundir . '/backup'
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p', 0700)
endif

let &viminfo="'1000,f1,<500,n" . g:rundir . '/' . g:viminfo_file

let &dir=g:rundir . '/swap'

if !isdirectory(&dir)
    call mkdir(&dir, 'p', 0700)
endif

let g:sessiondir=g:rundir . '/sessions'
if !isdirectory(g:sessiondir)
    call mkdir(g:sessiondir, 'p', 0700)
endif
let g:lastsession=g:rundir . '/last.' . g:appname

"----------------------------------------------------------------------------"
" indentation: use detectindent plugin
"----------------------------------------------------------------------------"
set autoindent
" Remove smartindent for now, thanks to this tip:
" http://vim.wikia.com/wiki/Restoring_indent_after_typing_hash
"set smartindent
set ts=8 sw=4 sts=4 tw=78 expandtab
"let g:detectindent_preferred_expandtab = 1
"let g:detectindent_preferred_tabsize = 8
"let g:detectindent_preferred_indent = 4
"let g:detectindent_verbosity = 0
"source ~/.vim/plugin/detectindent.vim
"au BufNewFile,BufRead * .* DetectIndent
"au BufReadPost * :DetectIndent

"----------------------------------------------------------------------------"
" syntax highlighting
"----------------------------------------------------------------------------"
syntax on

"----------------------------------------------------------------------------"
" highlighting extra/unwanted spaces
"----------------------------------------------------------------------------"
"source ~/.vim/whitespace.vim
source s:basedir . whitespace.vim

" xxx: ....and use F4 to do what we normally did automatically.
map <F4> <ESC>:% s/\s\+$//ge<CR>
map <F6> <ESC>:% s/#=============================================================================$/#===============================================================================/g<CR>

" xxx: ....and some other stuff while I'm here; F5 enters vim modeline
" boilerplate.
map <F5> <ESC>Go# vim:set ts=8 sw=4 sts=4 tw=78 et:<ESC>
"map <F7> <ESC>:set noai cin cino={2,>4,n-2,0(<CR>

"----------------------------------------------------------------------------"
" file types
"----------------------------------------------------------------------------"
filetype on
filetype plugin on

"----------------------------------------------------------------------------"
" gui-specific configuration
"----------------------------------------------------------------------------"
if has("gui_running")
    if !g:is_unix
        "set guifont=Consolas:h10:cANSI
        "set guifont=Monaco:h11
        "colorscheme darkblue
        "colorscheme trent_macvim
        hi Comment guifg=DarkGreen ctermfg=DarkGreen
        hi LineNr guifg=LightGreen
        "hi Comment ctermfg=DarkGreen
        "set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
        " set guifont=SAS_Monospace:h8:cANSI
        " set guifont=Lucida_Console:h8:cANSI
        " remove right and left scrollbars and toolbar
        set guioptions-=r
        set guioptions-=L
        set guioptions-=T
        set rnu

        hi LineNr guifg=LightGreen
        hi Comment ctermfg=DarkGreen
        hi Constant guifg=LightRed

    elseif has("gui_macvim")
        set guifont=Monaco:h12
        colorscheme trent_macvim
        set rnu
        hi LineNr guifg=LightGreen
        hi Comment ctermfg=DarkGreen
        hi Constant guifg=LightRed
        let macvim_hig_shift_movement = 1
        set vb
    endif
elseif g:is_cygwin
    colorscheme darkblue
    hi Comment ctermfg=DarkGreen
elseif g:is_unix
    colorscheme default
    hi Comment ctermfg=DarkGreen
endif

"----------------------------------------------------------------------------"
" spelling
"----------------------------------------------------------------------------"
au BufNewFile,BufRead *.txt,mutt*
    \ set spell spelllang=en_us ts=8 sw=4 sts=4 tw=72 expandtab

"----------------------------------------------------------------------------"
" default preferences for text files
"----------------------------------------------------------------------------"
au BufNewFile,BufRead *.txt set ts=8 sw=4 sts=4 tw=78 expandtab

au BufNewFile,BufRead *.py set ts=8 sw=4 sts=4 tw=78 expandtab

"----------------------------------------------------------------------------"
" paste-kludge and indent-toggle
"----------------------------------------------------------------------------"
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

function! MyIndentToggle()
    if &expandtab
        let msg = "tab-8"
        set shiftwidth=8
        set softtabstop=0
        set noexpandtab
    else
        let msg = "space-4"
        set shiftwidth=4
        set softtabstop=4
        set expandtab
    endif
    echo "switching to " . msg
endfunction

map <F3> <ESC>:call MyIndentToggle()<CR>

"----------------------------------------------------------------------------"
" python stuff
"----------------------------------------------------------------------------"
runtime plugin/pythonhelper.vim
hi User1 term=reverse gui=reverse
if !exists("*TagInStatusLine")
    function TagInStatusLine()
        return ''
    endfunction
endif

runtime plugin/syntastic.vim
if !exists("*SyntasticStatuslineFlag")
    function! SyntasticStatuslineFlag()
        return ''
    endfunction
endif

if !exists("*haslocaldir")
    function! HasLocalDir()
        return ''
    endfunction
else
    function! HasLocalDir()
        if haslocaldir()
            return '[lcd]'
        endif
        return ''
    endfunction
endif

set statusline=                 " my status line contains:
set statusline+=%n:             " - buffer number, followed by a colon
set statusline+=%<%f            " - relative filename, truncated from the left
set statusline+=\               " - a space
set statusline+=%h              " - [Help] if this is a help buffer
set statusline+=%m              " - [+] if modified, [-] if not modifiable
set statusline+=%r              " - [RO] if readonly
set statusline+=%2*%{HasLocalDir()}%*           " [lcd] if :lcd has been used
set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
set statusline+=\               " - a space
set statusline+=%1*%{TagInStatusLine()}%*       " [current class/function]
set statusline+=\               " - a space
set statusline+=%=              " - right-align the rest
set statusline+=%-10.(%l,%c%V%) " - line,column[-virtual column]
set statusline+=\               " - a space
set statusline+=%4L             " - total number of lines in buffer
set statusline+=\               " - a space
set statusline+=%P              " - position in buffer as percentage

" Other notes:
"   %1*         -- switch to highlight group User1
"   %{}         -- embed the output of a vim function
"   %*          -- switch to the normal highlighting
"   %=          -- right-align the rest
"   %-10.(...%) -- left-align the group inside %(...%)


"----------------------------------------------------------------------------"
" miscellaneous
"----------------------------------------------------------------------------"
set t_vb=
set showmatch
set showcmd
set ruler
set incsearch
set modeline
set modelines=5

" Try and make the backspace key behaviour suck less than usual.  For Windows,
" this is already taken care of for us by $VIMRUNTIME/mswin.vim.
if !g:is_windows
    set backspace=indent,eol,start whichwrap+=<,>,[,]
endif

if &term =~ 'xterm'
    if $COLORTERM == 'gnome-terminal'
        execute 'set t_kb=' . nr2char(8)
        fixdel
        set t_RV=
    elseif $COLORTERM == ''
        " Disabling the following as it's started breaking backspace behavior.
        "execute 'set t_kb=' . nr2char(8)
        "fixdel
    endif
endif

if g:is_darwin
    if g:hostname !~ 'viper.home.trent.me'
        set t_kb=
        fixdel
    endif

    " Don't clear the screen on exit.
    set t_ti=
    set t_te=
endif

if has("autocmd")
    autocmd FileType text setlocal textwidth=78
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" (Taken from vimrc_example.vim.)
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if !has("gui_macvim") && !g:is_windows
    set diffexpr=MyDiff()
    function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

fu! MyNERDTreeLayout(vsplits)
    " fyi 184 width is ideal for two 80 vsplits
    if a:vsplits == 0
        if &columns >= 269
            let vsplits = 3
        else
            let vsplits = 2
        endif
    else
        let vsplits = a:vsplits
    endif

    NERDTree
    vertical resize 14
    wincmd l

    let c = 1
    while c < vsplits
        vsp
        let c += 1
    endwhile
endfunction

fu! MyRNERDTreeLayout()
    vsp
    vsp
    vsp
    vsp
    wincmd l
    wincmd l
    wincmd l
    wincmd l
    vertical resize 14
endfunction

com! Nt  call MyNERDTreeLayout(0)
com! Nt2 call MyNERDTreeLayout(2)
com! Rt call MyRNERDTreeLayout()

source s:basedir . /plugin/yankring.vim
nmap <script> <silent> <unique> <Leader>r :YRShow<CR>

"----------------------------------------------------------------------------"
" post
"----------------------------------------------------------------------------"

"set verbose=9

set sessionoptions=unix,slash,blank,buffers,curdir,folds,globals,localoptions,options,tabpages,winpos,winsize

"let g:ConqueTerm_EscKey='<Esc>'
let g:ConqueTerm_EscKey='<C-k>'

if filereadable(g:lastsession)
    "exec 'source' g:lastsession
elseif has("gui_macvim")
"    autocmd VimEnter *
"        \ NERDTree
"        \ wincmd l
"        \ vsp
"        \ vsp
"        \ vsp
"        \ wincmd l
"        \ wincmd l
"        \ wincmd l
"        \ sp

"    autocmd VimEnter * wincmd l
"    autocmd VimEnter * vsp
"    autocmd VimEnter * vsp
"    autocmd VimEnter * wincmd l
"    autocmd VimEnter * wincmd l
"    autocmd VimEnter * wincmd l
"    autocmd VimEnter * sp
endif

let g:hostconfstage = 'late'
if filereadable(g:hostconf)
    exec 'source' g:hostconf
endif

" vim:set ts=8 sw=4 sts=4 expandtab:
