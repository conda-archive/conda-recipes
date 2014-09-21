" Vim color file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Jul 23

" This is the default color scheme.  It doesn't define the Normal
" highlighting, it uses whatever the colors used to be.

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

set background=dark
hi Normal guibg=Black guifg=White
hi Comment guifg=LimeGreen
hi Constant guifg=Red
hi Identifier guifg=DarkTurquoise
"hi Statement gui=BOLD guifg=RoyalBlue
hi Statement gui=BOLD guifg=RoyalBlue
hi pythonBuiltin guifg=DeepSkyBlue
hi pythonDecorator guifg=DarkOrange
hi pythonComment guifg=LimeGreen
hi pythonConditional guifg=SkyBlue
hi pythonStatement guifg=LightGoldenRod
hi pythonString guifg=PaleVioletRed
hi pythonException guifg=goldenrod
hi pythonExceptions guifg=VioletRed

hi cString guifg=PaleVioletRed
hi cConditional guifg=SkyBlue
hi cStatement guifg=LightGoldenRod
hi cParen guifg=plum
hi cOperator guifg=OliveDrab1
"hi cType guifg=DeepPink4
hi cType guifg=PaleTurquoise4
hi cNumber guifg=salmon4
hi cComment guifg=green3
hi cConstant guifg=PaleVioletRed4
hi cInclude guifg=DarkOrange4
hi cDefine guifg=maroon2
hi cStructure guifg=thistle1
hi cStorageClass guifg=turquoise1
hi cPreProc guifg=CadetBlue1
hi cPreCondit guifg=DarkOrange2
hi CursorLine guibg=grey13
hi Cursor guifg=white
hi lCursor guifg=white

let colors_name = "trent_macvim"

" vim: sw=2
