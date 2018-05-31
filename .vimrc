
" enable filetype
filetype on
filetype plugin on

" autocmd FileType c,h,hpp source ~/.vim/ident/c.vim
autocmd FileType c,cpp,c++ source ~/.vim/ident/cpp.vim
autocmd FileType c,cpp,c++ match ErrorMsg /\%>80v.\+/      " Mark lines > 80 chars
" autocmd   FileType py source ~/.vim/py.vim
autocmd FileType tex source ~/.vim/latex.vim
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType rb source ~/.vim/ruby.vim
augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
  au BufNewFile,BufRead *.scala set filetype=scala syntax=scala
  au BufNewFile,BufRead *.cu set filetype=cpp syntax=cpp
  au BufNewFile,BufRead *.cuh set filetype=cpp syntax=cpp
augroup END

set viminfo="NONE"

" go stuff
autocmd FileType go source ~/.vim/ident/go.vim
let go_highlight_trailing_whitespace_error = 0
""" au BufWritePost *.go !gofmt -w %    " it doesn't work
function Goformat()
    let regel=line(".")
    %!gofmt 2>/dev/null                 " it flickers the screen
    call cursor(regel, 1)
endfunction
"au BufWritePost *.go call Goformat()
map <C-f> call Goformat()               "ctrl+f for formatting go source codes
"imap <C-f> call Goformat()


" cpp11 stuff
let c_no_curly_error=1                                             " cpp11 {}
syn keyword cppOperator      alignof alignas
syn keyword cppType          char16_t char32_t decltype
syn keyword cppStorageClass  constexpr thread_local
syn keyword cppConstant      nullptr
syn keyword cppStatement     static_assert final override noexcept


colorscheme google


syntax on
set nu           " line numbering
set mousehide    " hide cursor when typing
set mouse=a      " enable mouse-support
set termencoding=utf-8 " terminal encoding
set novisualbell     "disable the bell and the visual flash
set t_vb=
"set columns=80
set backspace=indent,eol,start whichwrap+=<,>,[,] 
set nocompatible " vim, not vi
set showtabline=0

set nobackup
set noswapfile
set fileencodings=utf8,cp1251 " file encoding
set history=1000

" make the left and right arrow keys change line
set whichwrap+=<,>,[,] 

" ----------------------- hot keys ---------------------
" copy/paste ctrl+c/ctrl+v
vmap <C-C> "+yi
imap <C-V> <esc>"+gPi

" save
nnoremap <silent> <F2> :w<CR>
inoremap <silent> <F2> <Esc>:w<CR><Ins><Right>
"  nnoremap <silent> ^S :w<CR>
"  inoremap <silent> ^S <Esc>:w<CR><Ins><Right>
"  inoremap <C-s> <Space><BS><C-\><C-O>:update<CR>
"Add the following line to your shell configuration file (eg. ~/.bashrc) 
"to disable flow-control which is barely used in these days.
"    stty -ixoff -ixon
" And in your ~/.vimrc file
imap <C-s> <esc>:w<cr>a
map <C-s> :w<cr>


" press F10 to exit
nnoremap <silent> <F10> :q<CR>
inoremap <silent> <F10> <Esc>:q<CR>
"nnoremap <silent> <D-F10> :q<CR>
"inoremap <silent> <D-F10> <Esc>:q<CR>


" ------------------- json --------------
" json
autocmd BufNewFile,BufRead *.json set ft=javascript
" json prettyfier - format json press \jt 
map <leader>jt  <Esc>:%!python -m json.tool<CR>

"autocmd FileType rb source ~/.vim/javascript???.vim


" ---------------- thrift ---------------
au BufRead,BufNewFile *.thrift set filetype=thrift
au! Syntax thrift source ~/.vim/thrift.vim


" ---------------- vim copy/paste --------
"set clipboard=unnamedplus




" ------------------- code completion -----------------

" code completion#2   - ok!
function InsertTabWrapper()
 let col = col('.') - 1
 if !col || getline('.')[col - 1] !~ '\k'
 return "\<tab>"
 else
 "return "\<c-x>\<c-i>"
 return "\<c-p>"
 endif
endfunction
" show all possible options
imap <tab> <c-r>=InsertTabWrapper()<cr>
set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t

ino <silent> <F5>     <c-x><c-I>
set wildignore=*.o,*.bak
"set wildmode=longest,list,full
set wildmode=longest,list
set wildmenu




" ------------------------ Commenting ------------------------------
" COMMENTING A BLOCK OF LINES IN VISUAL MODE
"
"  add the lines below to your .vimrc file, go into visual mode w/ "v",
"  and hit "s" to comment the lines or "u" to uncomment them, this is
"  insanely useful. the lines below make this possible for C, C++, Perl,
"  Python, and shell scripts, but it's pretty easy to extend to other
"  languages

" C, C++
autocmd BufNewFile,BufRead *.h,*.c,*.cpp vmap u :-1/^\/\//s///<CR>
autocmd BufNewFile,BufRead *.h,*.c,*.cpp vmap s :-1/^/s//\/\//<CR>

" Perl, Python and shell scripts
autocmd BufNewFile,BufRead *.py,*.pl,*.sh vmap u :-1/^#/s///<CR>
autocmd BufNewFile,BufRead *.py,*.pl,*.sh vmap s :-1/^/s//#/<CR>

" highlight whitespaces
" match Todo /\s\+$/

" it removes trailing whitespaces automatically right before save
"autocmd BufWritePre *.c,*.cc,*.cpp,*.h :%s/\s\+$//e
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre *.c,*.cc,*.cpp,*.c++,*.h,*.py,*.pl,*.go :call <SID>StripTrailingWhitespaces()



" ----------------------- highlight ----------------------------
" Press F4 to toggle highlighting on/off, and show current value.
"noremap <F4> :set hlsearch! hlsearch?<CR>

" Press Space to turn off highlighting and clear any message already
" displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.

"nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
"nnoremap <F4> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\<'.expand('<cword>').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: on'
    return 1
  endif
endfunction


" VIM highlight variable under cursor like in netbeans
"""""nnoremap <F4> : printf('match IncSearch /\<%s\>/', expand('<cword>'))
"autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/',expand('<cword>'))



" ----------------------- SearchInside & Outside --------------------
" http://stackoverflow.com/questions/2683521/vim-search-in-c-c-code-lines/2696143#2696143
" :SearchInside String hello
" :SearchOutside Comment double

function! SearchWithSkip(pattern, flags, stopline, timeout, skip)
" Returns true if a match is found for {pattern}, but ignores matches
" where {skip} evaluates to false. This allows you to do nifty things
" like, say, only matching outside comments, only on odd-numbered lines,
" or whatever else you like.
"
" Mimics the built-in search() function, but adds a {skip} expression
" like that available in searchpair() and searchpairpos().
" (See the Vim help on search() for details of the other parameters.)
    " Note the current position, so that if there are no unskipped
    " matches, the cursor can be restored to this location.
    
    let l:matchpos = getpos('.')

    " Loop as long as {pattern} continues to be found.
    while search(a:pattern, a:flags, a:stopline, a:timeout) > 0
       " If {skip} is true, ignore this match and continue searching.
       if eval(a:skip)
            continue
       endif
       " If we get here, {pattern} was found and {skip} is false,
       " so this is a match we don't want to ignore. Update the
       " match position and stop searching.
       let l:matchpos = getpos('.')
       break
    endwhile

    " Jump to the position of the unskipped match, or to the original
    " position if there wasn't one.
    call setpos('.', l:matchpos)
endfunction

function! SearchOutside(synName, pattern)
" Searches for the specified pattern, but skips matches that
" exist within the specified syntax region.
   call SearchWithSkip(a:pattern, '', '', '',
     \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "' . a:synName . '"' )
endfunction

function! SearchInside(synName, pattern)
" Searches for the specified pattern, but skips matches that don't
" exist within the specified syntax region.
   call SearchWithSkip(a:pattern, '', '', '',
     \ 'synIDattr(synID(line("."), col("."), 0), "name") !~? "' . a:synName . '"' )
endfunction

" command! -nargs=+ -complete=command SearchOutside call SearchOutside(<f-args>)
" command! -nargs=+ -complete=command SearchInside  call SearchInside(<f-args>)

