" Name:          detectindent (global plugin)
" Version:       1.0
" Author:        Ciaran McCreesh <ciaran.mccreesh at googlemail.com>
" Updates:       http://github.com/ciaranm/detectindent
" Purpose:       Detect file indent settings
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.
"
" Usage:         :DetectIndent
"
"                " to prefer expandtab to noexpandtab when detection is
"                " impossible:
"                :let g:detectindent_preferred_expandtab = 1
"
"                " to set a preferred indent level when detection is
"                " impossible:
"                :let g:detectindent_preferred_indent = 4
"
" Requirements:  Untested on Vim versions below 6.2

if exists("loaded_detectindent")
    finish
endif
let loaded_detectindent = 1

if !exists('g:detectindent_verbosity')
    let g:detectindent_verbosity = 1
endif

fun! <SID>HasCStyleComments()
    return index(["c", "cpp", "java", "javascript", "php"], &ft) != -1
endfun

fun! <SID>IsCommentStart(line)
    " &comments aren't reliable
    return <SID>HasCStyleComments() && a:line =~ '/\*'
endfun

fun! <SID>IsCommentEnd(line)
    return <SID>HasCStyleComments() && a:line =~ '\*/'
endfun

fun! <SID>IsCommentLine(line)
    return <SID>HasCStyleComments() && a:line =~ '^\s\+//'
endfun

fun! <SID>DetectIndent()
    echo 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    let l:has_leading_tabs            = 0
    let l:has_leading_spaces          = 0
    let l:shortest_leading_spaces_run = 0
    let l:shortest_leading_spaces_idx = 0
    let l:longest_leading_spaces_run  = 0
    let l:max_lines                   = 1024
    if exists("g:detectindent_max_lines_to_analyse")
      let l:max_lines = g:detectindent_max_lines_to_analyse
    endif

    let verbose_msg = ''
    if ! exists("b:detectindent_cursettings")
      " remember initial values for comparison
      let b:detectindent_cursettings = {'expandtab': &et, 'shiftwidth': &sw, 'tabstop': &ts, 'softtabstop': &sts}
    endif

    let l:idx_end = line("$")
    let l:idx = 1
    while l:idx <= l:idx_end
        let l:line = getline(l:idx)

        " try to skip over comment blocks, they can give really screwy indent
        " settings in c/c++ files especially
        if <SID>IsCommentStart(l:line)
            while l:idx <= l:idx_end && ! <SID>IsCommentEnd(l:line)
                let l:idx = l:idx + 1
                let l:line = getline(l:idx)
            endwhile
            let l:idx = l:idx + 1
            continue
        endif

        " Skip comment lines since they are not dependable.
        if <SID>IsCommentLine(l:line)
            let l:idx = l:idx + 1
            continue
        endif

        " Skip lines that are solely whitespace, since they're less likely to
        " be properly constructed.
        if l:line !~ '\S'
            let l:idx = l:idx + 1
            continue
        endif

        let l:leading_char = strpart(l:line, 0, 1)

        if l:leading_char == "\t"
            let l:has_leading_tabs = 1

        elseif l:leading_char == " "
            " only interested if we don't have a run of spaces followed by a
            " tab.
            if -1 == match(l:line, '^ \+\t')
                let l:has_leading_spaces = 1
                let l:spaces = strlen(matchstr(l:line, '^ \+'))
                if l:shortest_leading_spaces_run == 0 ||
                            \ l:spaces < l:shortest_leading_spaces_run
                    let l:shortest_leading_spaces_run = l:spaces
                    let l:shortest_leading_spaces_idx = l:idx
                endif
                if l:spaces > l:longest_leading_spaces_run
                    let l:longest_leading_spaces_run = l:spaces
                endif
            endif

        endif

        let l:idx = l:idx + 1

        let l:max_lines = l:max_lines - 1

        if l:max_lines == 0
            let l:idx = l:idx_end + 1
        endif

    endwhile

    if l:has_leading_tabs && ! l:has_leading_spaces
        " tabs only, no spaces
        let l:verbose_msg = "Detected tabs only and no spaces"
        setl noexpandtab
        if exists("g:detectindent_preferred_indent")
            let &l:shiftwidth  = g:detectindent_preferred_indent
            let &l:tabstop     = g:detectindent_preferred_indent
        endif

    elseif l:has_leading_spaces && ! l:has_leading_tabs
        " spaces only, no tabs
        let l:verbose_msg = "Detected spaces only and no tabs"
        setl expandtab
        let &l:shiftwidth  = l:shortest_leading_spaces_run
        let &l:softtabstop = l:shortest_leading_spaces_run

    elseif l:has_leading_spaces && l:has_leading_tabs
        " spaces and tabs
        let l:verbose_msg = "Detected spaces and tabs"
        setl noexpandtab
        let &l:shiftwidth = l:shortest_leading_spaces_run

        " mmmm, time to guess how big tabs are
        if l:longest_leading_spaces_run <= 2
            let &l:tabstop = 2
        elseif l:longest_leading_spaces_run <= 4
            let &l:tabstop = 4
        else
            let &l:tabstop = 8
        endif

    else
        " no spaces, no tabs
        let l:verbose_msg = "Detected no spaces and no tabs"
        if exists("g:detectindent_preferred_indent") &&
                    \ exists("g:detectindent_preferred_expandtab")
            setl expandtab
            let &l:shiftwidth  = g:detectindent_preferred_indent
            let &l:softtabstop = g:detectindent_preferred_indent
        elseif exists("g:detectindent_preferred_indent")
            setl noexpandtab
            let &l:shiftwidth  = g:detectindent_preferred_indent
            let &l:tabstop     = g:detectindent_preferred_indent
        elseif exists("g:detectindent_preferred_expandtab")
            setl expandtab
        else
            setl noexpandtab
        endif

    endif

    if &verbose >= g:detectindent_verbosity
        echo l:verbose_msg
                    \ ."; has_leading_tabs:" l:has_leading_tabs
                    \ .", has_leading_spaces:" l:has_leading_spaces
                    \ .", shortest_leading_spaces_run:" l:shortest_leading_spaces_run
                    \ .", shortest_leading_spaces_idx:" l:shortest_leading_spaces_idx
                    \ .", longest_leading_spaces_run:" l:longest_leading_spaces_run

        let changed_msg = []
        for [setting, oldval] in items(b:detectindent_cursettings)
          exec 'let newval = &'.setting
          if oldval != newval
            let changed_msg += [ setting." changed from ".oldval." to ".newval ]
          end
        endfor
        if len(changed_msg)
          echo "Initial buffer settings changed:" join(changed_msg, ", ")
        endif
    endif
endfun

command! -bar -nargs=0 DetectIndent call <SID>DetectIndent()

