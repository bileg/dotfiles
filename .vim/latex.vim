
" ------------------- spell checking ----------------------- "
" ]s — next misspelled word
" [s — previous misspelled word
" z= — view spelling suggestions for a mispelled word
" zg — add a word to the dictionary
" zug — undo the addition of a word to the dictionary

" turn on spellchecking in Vim with the command :set spell and 
" turn off spellchecking with :set nospell.

set spell
setlocal spell spelllang=en_us


" ------------------- vim latex ---------------------------- "

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
"filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
"set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
"set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
"filetype indent on


" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
"let g:tex_flavor='latex'









" ************ TEST
" ----------------------- wrap text -----------------
" http://stackoverflow.com/questions/467739/how-do-you-get-vim-to-display-wrapped-lines-without-inserting-newlines
" http://contsys.tumblr.com/post/491802835/vim-soft-word-wrap
" Break lines intelligently when wrapping
set linebreak
set display+=lastline
set wrap
" not to break on words
set formatoptions=1
set linebreak
"set breakat=\ |@-+;:,./?^I    " XXX incorrect
" fixing up moving line by line in the paragraph
"nnoremap j gj
"nnoremap k gk
"vnoremap j gj
"vnoremap k gk

