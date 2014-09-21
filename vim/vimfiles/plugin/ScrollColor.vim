" ScrollColors.vim - Colorsheme Scroller, Chooser, and Browser
"
"     Author and maintainer: Yakov Lerner <iler_ml@fastmail.fm>
"     Last Change: 2006-07-18
"
" SYNOPSIS:
"   This is colorscheme Scroller/Chooser/Browser.
"   With this plugin, you walk through installed 
"   colorschemes using arrow keys.
"
" SHORT USAGE DESCRIPTION:
"   Drop ScrollColors.vim into your plugin directory. 
"   Type :SCROLL    
"   Use arrow keys to walk through colorschemes, ? for help, Esc to exit.
"
" DETAILED DESCRIPTION:
"   1. source ScrollColors.vim  " or drop ScrollColors.vim into
"                          " your ~/.vim/plugins directory
"   2. Type :SCROLL
"   3. Use arrows to scroll thgough colorschemes.
"   4. When done, press Esc to exit. You will be prompted
"      wether to 
"
"   You can download 140 colorschemes pack from:
"        http://www.vim.org/scripts/script.php?script_id=625
"   Having 140 installed colorschemes is in no way prerequisite for
"   ScrollColors. But with ScrollColors you can preview 140 colorschemes
"   in couple of minutes.
"
" CUSTOM KEY MAPPINGS:
"   You can map two keys of your choice to NextColor and PrevColor actions.
"   Choose pair of shortcut keys (for example <F2> and <f3>, or \n and \p)
"   and map them as follows:
"      map <silent><F3> :NEXTCOLOR<cr>
"      map <silent><F2> :PREVCOLOR<cr>


if exists("g:scroll_colors") | finish | endif
let g:scroll_colors = 1

command! COLORSCROLL :call s:ColorScroller()
command! SCROLLCOLOR :call s:ColorScroller()
command! NEXTCOLOR   :call s:NextColorscheme()
command! PREVCOLOR   :call s:PrevColorscheme()

" Example of convenience mappings:
"map <silent><F3> :NEXTCOLOR<cr>
"map <silent><F2> :PREVCOLOR<cr>
"map <silent><F4> :SCROLLCOLOR<cr>

function! s:ScrollerHelp()
    echo " "
    echohl Title
    echo "Color Scroller Help:"
    echo "--------------------"
    echohl NONE
    echo "Arrows       - change colorscheme"
    echo "Esc,q,Enter  - exit"
    echo "h,j,k,l      - change colorscheme"
    echo "0,g          - go to first colorscheme"
    echo "$,G          - go to last colorscheme"
    echo "L            - list colorschemes"
    echo "PgUp,PgDown  - jump by 10 colorschemes"
    echo "#            - go to colorscheme by index (1-N)"
    echo "R            - refresh colorscheme list"
    echo "?            - this help text"
    echohl MoreMsg
    echo "Press any key to continue"
    echohl NONE
    call getchar()
endfu

function! s:Align(s, width)
    if strlen(a:s) >= a:width
        return a:s." "
    else
        let pad="                       "
        let res=a:s
        while strlen(res) < a:width
            let chunk = (a:width - strlen(res) > strlen(pad) ? strlen(pad) : a:width - strlen(res))
            let res = res . strpart(pad,0,chunk)
        endw
        return res
    endif
endfu

function! s:ListColors()
    echo " "
    let list=s:GetColorschemesList()
    let width=18
    let pos=0
    while list != ''
        let str=substitute(list,"\n.*","","")
        let list=substitute(list,"[^\n]*\n", "", "")
        let aligned = s:Align(str, width)
        if( pos+strlen(aligned)+1 >= &columns)
            echo " "
            let pos=0
        endif
        echon aligned
        let pos = pos + strlen(aligned)
    endw
    echo "Press any key to continue"
    call getchar()
endfu

function! s:CurrentColor()
    return exists("g:colors_name") ? g:colors_name : ""
endfu

function! s:SetColor(name)
    exe "color ".a:name
    " if we do not assign a:colors_name, then
    " bad things happen if file colors/name.vim conmtains wrong assignment inside.
    " Wrong assignment inside happens when file was copied but
    " assignment inside not fixed.
    " Such wrong assignment cause up erratic switches unless
    " we do our own assignment to g:colors_name
    let g:colors_name=a:name
endfu

function! s:JumpByIndex(list,total)
    let ans = input("Enter colorscheme number (1-".a:total.") : ")
    let index = (ans<=0? 1 : 1+(ans-1)%a:total )
    let name = s:EntryByIndex(a:list, index )
    call s:SetColor(name)
endfu

function! s:JumpByIndex2(list,total, index)
    let mod = (a:index <= 0? 1 : 1+(a:index-1)%a:total )
    let name = s:EntryByIndex(a:list, mod )
    call s:SetColor(name)
endfu

function! s:ExitDialog(old, action)
    let ans = 0

    if a:old == s:CurrentColor()
        let ans=1
    elseif a:action == ''
        let ans = confirm("Keep this colorscheme ?", "&Yes\n&No\n&Cancel")
    elseif action == 'keep'
        ans = 1
    elseif action == 'revert'
        ans = 2
    endif

    if ans == 1 || ans==0
    " exit, keep colorscheme
        let msg = (a:old == s:CurrentColor() ? '' : "(original: '".a:old."')")
        call s:FinalEcho( msg )
    elseif ans == 2 
    " exit, revert colorscheme
        call s:SetColor(a:old)
        call s:FinalEcho('original color restored')
    elseif ans == 3
    " do not exit, continue browsing
        return -1
    endif
endfu

function! s:ColorScroller()
    let old = s:CurrentColor()
    let list = s:GetColorschemesList()
    let total = s:CountEntries(list)
    let loop=0

    if line("$") == 1 && getline(1) == "" && bufnr('$')==1
    " if buffer is empty, open something
        echo "We will open sample text with syntax highlighting."
        echo "Watch for the guiding prompt in the bottom line."
        echo "When the text will open, use Arrow keys to switch colorschemes, ? for help."
        echo " "
        echo "Press any key to continue"
        call getchar()
        :e $VIMRUNTIME/syntax/abc.vim
        :setlocal ro
        syntax on
        redraw
    endif

    if !exists("g:syntax_on")
        syntax on
        redraw
    endif

    while 1
        redraw
        let index = s:FindIndex(list, s:CurrentColor())
        echo "["
        echohl Search
        echon s:CurrentColor()
        echohl NONE
        if loop == 0
            echon "] ColorScroller: "
            echohl MoreMsg | echon "Arrows" | echohl NONE | echon "-next/prev; "
            echohl MoreMsg | echon "Esc" | echohl NONE | echon "-exit; "
            echohl MoreMsg | echon "?" | echohl NONE | echon "-help > "
        else
            echon "] "
            echon " " . index . "/" . total . " "
            echon s:Align("", 12-strlen(s:CurrentColor()))
            echon "> ColorScroll > "
            echon "Arrows,Esc,? > "
        endif
        let key = getchar()
        let c = nr2char(key)

        if     key == "\<Left>" || key == "\<Up>" || c ==# 'h' || c ==# 'j'
            call s:PrevSilent()
        elseif key == "\<Down>" || key == "\<Right>" || c ==# 'l' || c==# 'k' || c==# ' '
            call s:NextSilent()
        elseif c==# 'g' || c=='0' || c=='1'
            call s:SetColor( s:GetFirstColors() )
        elseif c=='$' || c==# 'G'
            call s:SetColor( s:GetLastColors() )
        elseif c ==# 'L'
        " command 'L' list colors
            call s:ListColors()
        elseif c=='Z' || c=='z' || key == 13 || c=='q' || c=='Q' || c==':' || key == 27
            if s:ExitDialog(old, '') != -1
                break
            endif
        elseif key == 12 " c=="\<C-L>"
            redraw
        elseif c == '#'
            call s:JumpByIndex(list,total)
        elseif key == "\<PageDown>"
            call s:JumpByIndex2(list,total, (index-10>=1 ? index-10 : index-10+total))
        elseif key == "\<PageUp>"
            call s:JumpByIndex2(list,total, index+10)
        elseif c == '?'
            call s:ScrollerHelp()
        elseif c == 'R'
            call s:RefreshColorschemesList()
            echo "Colorscheme list refreshed. Press any key to continue."
            call getchar()
        else
            call s:ScrollerHelp()
        endif
        let loop = loop + 1
    endw
endfu

" Get 1-based index of 'entry' in \n-separated 'list'
function! s:FindIndex(list,entry)
     " we assume entry has no special chars or we could escape() it
     let str = substitute("\n" . a:list . "\n", "\n" . a:entry . "\n.*$", "", "")
     return 1 + s:CountEntries(str)
endfu

" Get list element by 1-based index
function! s:EntryByIndex(list,index)
    let k=1
    let tail=a:list 
    while tail != '' && k < a:index
        let tail=substitute(tail, "^[^\n]*\n", "", "")
        let k = k + 1
    endw
    let tail = substitute(tail, "\n.*$", "", "")
    return tail
endfu

function! s:MakeWellFormedList(list) 

    " make sure last \n is present
    let str=a:list."\n"
    " make sure leading \n are not present
    let str=substitute(str, "^\n*", "", "")
    " make sure entries are separated by exactly one \n
    let str=substitute(str, "\n\\+", "\n", "g")

    return str
endfu

function! s:CountEntries(list)
    let str = s:MakeWellFormedList(a:list)

    let str=substitute(str, "[^\n]\\+\n", ".", "g")

    return strlen(str)
endfu

function! s:RemoveDuplicates(list)
    let sep = "\n"
    let res = s:MakeWellFormedList(a:list . "\n")
    let beg = 0
    while beg < strlen(res)
        let end = matchend(res, sep, beg)
        let str1 = strpart( res, beg, end - beg)
        let res = strpart(res,0,end) . substitute("\n".strpart(res,end), "\n".str1,"\n","g") 
        let res = substitute(res, "\n\\+", "\n", "g")
        let beg = end
    endw
    return res
endfu

if v:version >= 700

" s:SortVar(): sort components of string @var separated
" by delimiter @sep, and returns the sorted string.
" For example, s:SortVar("c\nb\na", "\n") returns "a\nb\nc\n"
function! s:SortVar(list, sep)
    let list = split( a:list, a:sep )
    let sorted = sort(list)
    let result = join( sorted, "\n" )
    return result . "\n"
endfun

endif

if v:version < 700
" s:SortVar(): sort components of string @var separated
" by delimiter @sep, and returns the sorted string.
" For example, s:SortVar("c\nb\na", "\n") returns "a\nb\nc\n"
function! s:SortVar(list, sep)

   let res=s:MakeWellFormedList(a:list . "\n")
   while 1
      let disorder=0
      let index1=0

      let len=strlen(res)
      while 1
         let index2=matchend(res, a:sep, index1)
         if index2 == -1 || index2>=len
            break
         endif
         let index3=matchend(res, a:sep, index2)
         if index3 == -1
            let index3=len
         endif
         let str1=strpart(res, index1, index2-index1)
         let str2=strpart(res, index2, index3-index2)
         if str1 > str2
            let disorder=1
            " swap str1 and str2 in res
            let res=strpart(res,0,index1).str2.str1.strpart(res,index3)
             let index1=index1 + strlen(str2)
         else
            let index1=index1 + strlen(str1)
         endif
      endw

      if !disorder
        break
      endif
   endw
   return res
endfu
endif " v:version < 700

let s:list = ""

function! s:GetColorschemesList()
   if s:list == ""
       let s:list = s:RefreshColorschemesList()
   endif
   return s:list
endfunction


function! s:RefreshColorschemesList() 
    let x=globpath(&rtp, "colors/*.vim")
    let y=substitute(x."\n","\\(^\\|\n\\)[^\n]*[/\\\\]", "\n", "g")
    let z=substitute(y,"\\.vim\n", "\n", "g")
    let sorted = s:SortVar(z, "\n")
    let s:list = s:RemoveDuplicates(sorted)
    return s:list
endfun

function! s:GetFirstColors() 
    let list=s:GetColorschemesList()
    let trim=substitute(list, "^\n\\+", "", "")
    return substitute(trim, "\n.*", "", "")
endfu

function! s:GetLastColors()
    let list=s:GetColorschemesList()
    let trim=substitute(list, "\n\\+$", "", "")
    return substitute(trim, "^.*\n", "", "")
endfu

function! s:FinalEcho(suffix)
    let list = s:GetColorschemesList()
    let total = s:CountEntries(list)
    let index = s:FindIndex(list, s:CurrentColor())

    redraw
    echon "["
    echohl Search
    echon  s:CurrentColor()
    echohl NONE
    echon "] colorscheme #".index ." of " . total.". "
    echon  a:suffix
endfu

function! s:GetNextColor(color)
    let list=s:GetColorschemesList()
    if ("\n".list) =~ ("\n".s:CurrentColor()."\n")
        let next=substitute("\n".list."\n", ".*\n".a:color."\n", "", "")
        let next = substitute(next, "\n.*", "", "")
        return next=='' ? s:GetFirstColors() : next
    else
        return s:GetFirstColors()
    endif
endfu

function! s:GetPrevColor(color)
    let list=s:GetColorschemesList()
    if ("\n".list) =~ ("\n".a:color."\n")
        let prev=substitute("\n".list."\n", "\n".a:color."\n.*", "", "")
        let prev=substitute(prev, "^.*\n", "", "")
        return prev=='' ? s:GetLastColors() : prev
    else
        return s:GetLastColors()
    endif
endfu

function! s:NextSilent()
    let old = s:CurrentColor()
    let next = s:GetNextColor(s:CurrentColor())
    call s:SetColor( next )
endfu

function! s:PrevSilent()
    let old = s:CurrentColor()
    let prev = s:GetPrevColor(s:CurrentColor())
    call s:SetColor( prev )
endfu

function! s:NextColorscheme()
    let old = s:CurrentColor()
    let next = s:GetNextColor(s:CurrentColor())
    call s:SetColor( next )
    redraw
    call s:FinalEcho('previous: '.old)
endfun

function! s:PrevColorscheme()
    let old = s:CurrentColor()
    let prev = s:GetPrevColor(s:CurrentColor())
    call s:SetColor( prev )
    redraw
    call s:FinalEcho('previous: '.old)
endfun

command! CN :call s:NextColorscheme()
command! CP :call s:PrevColorscheme()
map \n :CN<cr>
map \p :CP<cr>
map \c :echo g:colors_name<cr>

" 2006-07-18 fixed bug with Align() -> s:Align() (affected L command)
" 2006-07-18 added colorlist cache (s:list)
" 2006-07-18 added R key to refresh colorlist
" 2006-07-19 for vim7, sort using builtin sort() (bubblesort is slow)
