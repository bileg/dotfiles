"+-------------------------------------------------+
"|                                                 |
"| VIM macros for Latex                            |
"|                                                 |
"| Tomer Kol                                       |
"|                                                 |
"| Version:       0.36                             |
"| Last changed:  4 Apr 2000                       |
"|                                                 |
"| Copyright: 1998,1999 Tomer Kol                  |
"|                                                 |
"|    This work is distributed under the GPL       |
"|   ("GNU GENERAL PUBLIC LICENSE" version 2 or    |
"|     any later version) and is provided "as is". |
"|                                                 |
"|  If you fix bugs/enhance it, please send me     |
"|  a copy, so I may include it in the "official"  |
"|  version.                                       |
"|                                                 |
"| Email: tkol@psl-palm.technion.ac.il             |
"+-------------------------------------------------+

" See initialization code at the end of the file

"+=====================================================+
"||                                                   ||
"||                 Functions                         ||
"||                                                   ||
"+=====================================================+

"+=====================================================+
"|                                                     |
"+=====================================================+
function! TKversion()
  let TKver = "0.36 (4 Apr 2000)"
  let Msg="You are using TKlatex VIM macros\nversion ".TKver
  let Msg=Msg."\nCreated by Tomer Kol"
  let rc = confirm(Msg, "&OK")
  return TKver
endfunction

"+=====================================================+
"|                                                     |
"|     Auxiliary functions                             |
"|                                                     |
"+=====================================================+


"+-----------------------------------------------------+
"| TKisFirstFileNewer                                  |
"| Returns: 1 first file is newer                      |
"|          0 first file is not newer                  |
"|         -1 Error                                    |
"| NOTE: uses the "ls -1t" function -- make sure you   |
"|       have it (e.g, for Win* you'll need ls.exe)    |
"+-----------------------------------------------------+
" NT dir /O-D /B  !!!!!!!!! not working on all win95 !!!
function! TKisFirstFileNewer(FileA, FileB)
  let Res =-1
  if filereadable(a:FileA)
    if filereadable(a:FileB)
      exe "normal :read! ls -t1 ".a:FileA." ".a:FileB."\<CR>"
      exe "-1"
      let NewerFile = getline(".")
      let Res = ( NewerFile == a:FileA)
      "remove traces
      exe "normal u"
    endif
  endif 

  return Res
endfunction

"+-----------------------------------------------------+
"| TKinsertline(content)                               |
"+-----------------------------------------------------+
function! TKinsertline(content)
  exe "normal i".a:content."\<cr>\<esc>"
endfunction

"+-----------------------------------------------------+
"| TKstringPresentInfile(StringToFind, FileName)       |
"| return:  1 if string exists in file                 |
"|          0 is string isn't found                    |
"|         -1 error (such as file not readable)        |
"|                                                     |
"+-----------------------------------------------------+
function! TKstringPresentInfile(StringToFind, FileName)
  if  !filereadable(a:FileName)
    return -1
  endif

  if !has("win32")  " UNIX :-)
    "let Execom = "!grep -q \"".a:StringToFind."\" ".a:FileName
    let Execom = "!grep  \"".a:StringToFind."\" ".a:FileName
    execute Execom
    "grep exit status is 0 if it finds the word "
    if shell_error == 0
       let RC = 1
    else
       let RC = 0
    endif
  else  " Win32 :-(
    execute "normal :0split\<CR>:e ".a:FileName."\<CR>"
    " open a first line in case the string is the file's first line
    execute "normal O\<Esc>"
    echo "If you get an error message now, just IGNORE it!!!\n"
    let OrigHL=&hl
    " don't print red error message if not found
    let &hl="e:Normal"
    execute "normal /".a:StringToFind."\<CR>"
    if line(".") != 1
      let RC = 1
    else
      let RC = 0
    endif
    execute "normal u:q\<CR>"
    let &hl=OrigHL
  endif

  return RC
endfunction

"+-----------------------------------------------------+
"| TKFilesDiffer(FileNameA, FileNameB)                 |
"| return:  0 if files are identical                   |
"|          1 if files are not identical               |
"|         -1 error (such as file not readable)        |
"|                                                     |
"+-----------------------------------------------------+
function! TKFilesDiffer(FileNameA, FileNameB)
  if !filereadable(a:FileNameA)
    return -1
  endif
  if !filereadable(a:FileNameB)
    return -1
  endif
  if !has("win32")  " UNIX :-)
     "let Execom= "!diff -q ".a:FileNameA." ".a:FileNameB
     let Execom= "!diff  ".a:FileNameA." ".a:FileNameB
     execute Execom
     " diff exits with 0 if the files are identical
     let RC = shell_error
  else  " Win32 :-(
    execute "normal :0split\<CR>:e ".tempname()."\<CR>"
    execute ":r! diff ".a:FileNameA." ".a:FileNameB
    if line("$") == 1
      let RC = 0
    else
      let RC = 1
    endif
    execute "normal u:q!\<CR>"
  endif

  return RC
endfunction


"+=====================================================+
"|                                                     |
"|   Functions for support of producing/viewing LaTeX  |
"|   and for the gui.                                  |
"|                                                     |
"+=====================================================+

"+-----------------------------------------------------+
"| TKSetTeXfileName(...)                               |
"|                                                     |
"| MODE: 0 (default) set name of current buffer        |
"|       1 query user                                  |
"|       2 Set to the second parameter                 |
"|       3 Just verify that file is in the current     |
"|         directory.                                  |
"+-----------------------------------------------------+
function! TKSetTeXfileName(...)
  if a:0 == 0
    let g:TeXfile = bufname("%")
  else
    "we have parameters
    if a:1 == 0
      let g:TeXfile = bufname("%")
    elseif a:1 == 1
      let DefaultAction = 2 "use current buffer name 
      if ! exists("g:TeXfile")
        let InputPrompt= "\nThe name of the main TeX file was not defined yet.\n"
        let g:TeXfile = bufname("%")
      else
        let DefaultAction = 1 "keep current main file
        let InputPrompt= "\nThe current name of the main TeX file is "
        let InputPrompt= InputPrompt.g:TeXfile."\n"
        let InputPrompt= InputPrompt."Just press ENTER to keep it.\n"
      endif
      let CurBufName=  bufname("%")
      let InputPrompt= InputPrompt."The name of the current buffer is ".CurBufName
      let Options = "Keep current name\nUse &Buffer name\n&Enter new name"
      let RC = confirm(InputPrompt, Options, DefaultAction)
      if RC == 2
        let g:TeXfile = CurBufName
      elseif RC == 3
        let InputPrompt= InputPrompt."\nEnter name of the main TeX file  \["
        let InputPrompt= InputPrompt.g:TeXfile."\]\n"
        let EnteredFileName=input(InputPrompt)
        if EnteredFileName != ""
          let g:TeXfile = EnteredFileName
        endif
      endif
    elseif a:1 == 2
      if a:0 > 1 " we need a second parameter
        let g:TeXfile = a:2
      else
        let RC = confirm("Missing parameter when calling TKSetTeXfileName", "OK")
        return
      endif
    endif 
  endif 

  let FilePath = fnamemodify(g:TeXfile, ":p:h")
  if  FilePath != getcwd()
    let Msg =     "TeX file (".g:TeXfile.") is not in the current "
    let Msg = Msg."directory \n(which is ".getcwd().")\n\n"
    let Msg = Msg."NOTE: auxiliary files (idx etc.) are looked for\n"
    let Msg = Msg."      in the current directory\n\n"
    let Msg = Msg."choose \"Change dir\" to go to the file\'s directory"
    let Msg = Msg." (RECOMMENDED)\n"
    let RC = confirm(Msg,"&Change dir\nKeep current dir", 1)
    if RC == 1
      exe "cd ".FilePath
      let g:TeXfile = fnamemodify(g:TeXfile, ":t")
    endif
  endif

  call TKSetTitle()
endfunction

"+-----------------------------------------------------+
"| Run LaTeX once (no makeindex etc.)                  |
"+-----------------------------------------------------+
function! TKLatexOnly()
  if ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  " Verify file exists
  if ! filereadable(g:TeXfile)
    let Msg = "TeX file ".g:TeXfile." unreadable !!! \n"
    let Msg = Msg."Wrong name ?? \n\n"
    let Msg = Msg."NOTE: the current directory is ".getcwd()." \n"
    let Msg = Msg."      the current buffer's path is "
    let Msg = Msg.fnamemodify(bufname("%"), ":p:h")."\n\n"

    let RC = confirm(Msg, "&OK")
    return 1
  else
    " verify TeX file is in the current directory
    call TKSetTeXfileName(3)
  endif

  echo ">>>> Running LaTeX <<<<<<"
  let Execom = "!".g:TKlatexProg." ".g:TeXfile
  execute Execom

endfunction

"+-----------------------------------------------------+
"| TKMakeDVIfile                                       |
"| (based on latexn + changes)                         |
"|                                                     |
"| NOTE: tested using LaTeX2e  (2.09 not tested)       |
"|                                                     |
"|                                                     |
"| optional argument - max number of iterations        |
"|                    (5 will ensure correct DVI)      |
"|                                                     |
"| NOTE: Due to win95 bug, shell_error is always 0,    |
"|       thus it cannot detect errors code returned by |
"|       LaTeX, and may try to LaTeX again.            |
"| Solution: 1. Change your operating system ;-)       |
"|              (I recommend Linux, but NT will do)    |
"|           2. Call the function with the optional    |
"|              argument.                              |
"+-----------------------------------------------------+
function! TKMakeDVIfile(...)
  if ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  " Verify file exists
  if ! filereadable(g:TeXfile)
    let Msg = "TeX file ".g:TeXfile." unreadable !!! \n"
    let Msg = Msg."Wrong name ?? \n\n"
    let Msg = Msg."NOTE: the current directory is ".getcwd()." \n"
    let Msg = Msg."      the current buffer's path is "
    let Msg = Msg.fnamemodify(bufname("%"), ":p:h")."\n\n"

    let RC = confirm(Msg, "&OK")
    return 1
  else
    " verify TeX file is in the current directory
    call TKSetTeXfileName(3)
  endif


  let TeXfileBasename = fnamemodify(g:TeXfile, ":t:r")

  " don't stop when the screen fills
  let OrigMoreVal = &more
  let &more=0
  """""""""""""""""""""""""""""""""
  " Rerun enough times
  """""""""""""""""""""""""""""""""
  let Count = 0
  let NeedToRerun = 1
  if a:0 > 0
    let MaxRuns = a:1
  else
    let MaxRuns = 5
  endif
  " There is no point in running more then 5 iterations
  if MaxRuns > 5
    let MaxRuns = 5
  endif
  
  while  NeedToRerun && Count < MaxRuns
    let NeedToRerun = 0
    let Count = Count + 1
    echo "\n>>>  Beginning LaTeX Run # ".Count."  <<<\n"

    "backup old idx file, then run Makeindex
    if filereadable(TeXfileBasename.".idx")
      let Execom = "!".g:TKcpCmd." ".TeXfileBasename.".idx "
      let Execom = Execom.TeXfileBasename.".idx.bak"
      execute Execom
      let Execom = "!makeindex ".TeXfileBasename.".idx"
      execute Execom
    endif

    " Run bibtex if needed
    if  Count == 1
      if TKstringPresentInfile("\\\\bibdata", TeXfileBasename.".aux") == 1
        let Execom = "!bibtex ".TeXfileBasename
        execute Execom
      endif
    endif

    " make a backup of old bbl file
    if filereadable(TeXfileBasename.".bbl")
      let Execom = "!".g:TKcpCmd." ".TeXfileBasename.".bbl "
      let Execom = Execom.TeXfileBasename.".bbl.bak"
      execute Execom
    endif

    " latex the file
    echo ">>>> Running LaTeX <<<<<<"
    let Execom = "!".g:TKlatexProg." ".g:TeXfile
    execute Execom
    if shell_error != 0
      let ErrorInLatex = 1
    else
      let ErrorInLatex = 0
    endif

    " An Ugly hack for Win95
    if has("win32") && ErrorInLatex == 0
      " Win 95 always return 0
      " Win NT is (more or less) a normal OS
      if $OS != "Windows_NT"
        if TKstringPresentInfile("^!", TeXfileBasename.".log") == 1
           let Msg = "It seems you had an error while LaTeXing\n"
           let Msg = Msg."As it seems you're using win95 :-(, \n" 
           let Msg = Msg."I cannot be sure due to one of the\n"
           let Msg = Msg."bugs in that \"OS\""
           let RC = confirm(Msg, "There was an &error\nEverything was fine")
           if RC == 1
             let ErrorInLatex = 1
          endif
        endif
      endif
    endif
  
    "Abort on errors ?
    if ErrorInLatex
      let Msg = ">>>>>  LaTeX returned error  <<<<< \n"
      let Msg = Msg." "
      let RC=confirm(Msg, "&Abort\n&Load log file\n&Jump to Error")
      if RC == 1
        return 1
      elseif RC == 2
        execute "normal :split\<CR>:e ".TeXfileBasename.".log\<CR>"
        execute "normal /^l\\.\<CR>"
        return 1
      else  " Jump to Error
        execute "normal :split\<CR>:e ".TeXfileBasename.".log\<CR>"
        execute "normal /^l\\.\<CR>"
	let ErrorLine = getline(".")
	let LineNumEnd = match(ErrorLine, " ")
	let ErrorLineNum = strpart( ErrorLine, 2, LineNumEnd-1)
	execute "normal [("
	let ErrFileLine = getline(".")
	" erase the ( to isolate the file's name
        let St = match(ErrFileLine, "(") 
        let ErrneousFileName = strpart(ErrFileLine, St+1, strlen(ErrFileLine))
        execute ":e ".ErrneousFileName
	execute ":".ErrorLineNum
        return 1
      endif
    endif

    " see if we need to Rerun
    if TKstringPresentInfile("Rerun", TeXfileBasename.".log") == 1
      let NeedToRerun = 1
    endif

    " Run bibtex if needed
    if  Count == 1
      if TKstringPresentInfile("\\\\bibdata", TeXfileBasename.".aux") == 1
        let Execom = "!bibtex ".TeXfileBasename
        execute Execom
        " See if bbl file changed
        if TKFilesDiffer(TeXfileBasename.".bbl", TeXfileBasename.".bbl.bak") == 1
          let NeedToRerun = 1
        endif
      endif
    endif

    " See if idx file changed
    if TKFilesDiffer(TeXfileBasename.".idx", TeXfileBasename.".idx.bak") == 1
      let NeedToRerun = 1
    endif

  endwhile

  " Remove bak files
  if  filereadable(TeXfileBasename.".idx.bak")
    let Execom = "!".g:TKrmCmd." ".TeXfileBasename.".idx.bak"
    execute Execom
  endif
  if  filereadable(TeXfileBasename.".bbl.bak")
    let Execom = "!".g:TKrmCmd." ".TeXfileBasename.".bbl.bak"
    execute Execom
  endif

  echo ">>>>>>>>>  DONE   <<<<<<<<<<<<<"
  echo g:TeXfile." was LaTeXed ".Count." time(s)"
  echo ">>>>>>>>>  DONE   <<<<<<<<<<<<<"

  "restore original value of the more option
  let &more = OrigMoreVal 
  return 0
endfunction

"+-----------------------------------------------------+
"|  TKMakePSfile                                       |
"|  parameter:                                         |
"|    "makemode" - regenerate DVI if .tex newer        |
"+-----------------------------------------------------+
function! TKMakePSfile(...)
  if ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  let TeXfileBasename = fnamemodify(g:TeXfile, ":t:r")
  let DVIfilename = TeXfileBasename.".dvi"

  "verify the dvi file exists
  if  ! filereadable(DVIfilename)
    " No DVI file found, trying to generate
    if  filereadable(g:TeXfile)
      let RC = TKMakeDVIfile()
      if RC != 0
        return RC
      endif
    endif
  endif

  if TKisFirstFileNewer(g:TeXfile, DVIfilename) == 1
    " TeX file exists and is newer then DVI file
    " NOTE: files included from the main tex file are not checked
    let Remake = "query"
    if a:0 > 0
      if a:1 == "makemode"
        let Remake = 1
      endif
    endif
    if  Remake == "query"
      let Msg = "NOTE: ".g:TeXfile." is newer then ".DVIfilename."\n\n"
      let Msg = Msg."Regenerate DVI file  (recommended)?"
      let Remake = confirm(Msg, "&Yes\n&No", 1)
    endif
    if Remake == 1
      let RC = TKMakeDVIfile()
      if RC != 0
        return RC
      endif
    endif
  endif

  if  filereadable(DVIfilename)
    " Call dvips
    let Execom = "!".g:TKdvi2psProg." -o ".TeXfileBasename.".ps "
    let Execom = Execom.TeXfileBasename.".dvi"
    execute Execom
  else
    let Msg = "Failed to create DVI file !! \n\n"
    let Msg = Msg."(".g:TKdvi2psProg." will not be called)\n\n"
    let RC = confirm(Msg, "&Ok")
  endif

  return 0
endfunction


"+-----------------------------------------------------+
"|  TKMakePDFfile                                      |
"|                                                     |
"+-----------------------------------------------------+
function! TKMakePDFfile()
  if ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  let TeXfileBasename = fnamemodify(g:TeXfile, ":t:r")
  let DVIfilename = TeXfileBasename.".dvi"
  let PSfilename = TeXfileBasename.".ps"

  "verify the PS file exists
  if  ! filereadable(PSfilename)
    " No PS file found, trying to generate
    let RC = TKMakePSfile()
    if RC != 0
      return RC
    endif
  endif

  let NeedMake = 0
  let Msg = ""
  if TKisFirstFileNewer(DVIfilename, PSfilename) == 1
    " DVI file exists and is newer then PS file
    let Msg = "NOTE: ".DVIfilename." is newer then ".PSfilename."\n\n"
    let NeedMake = 1
  endif
  if TKisFirstFileNewer(g:TeXfile, DVIfilename) == 1
    " TeX file exists and is newer then DVI file
    let Msg = Msg."NOTE: ".g:TeXfile." is newer then ".DVIfilename."\n\n"
    let NeedMake = 1
  endif
  if NeedMake 
    let Msg = Msg."Regenerate outdated files (recommended)?"
    let Remake = confirm(Msg, "&Yes\n&No", 1)
    if Remake == 1
      let RC = TKMakePSfile("makemode")
      if RC != 0
        return RC
      endif
    endif
  endif


  if  filereadable(PSfilename)
    " Call ps2pdf
    let Execom = "!".g:TKps2pdfConv." ".PSfilename." ".TeXfileBasename.".pdf"

    echo "\n\n>>> PLEASE WAIT, it takes time <<<\n\n"
    execute Execom
  else
    let Msg = "Failed to create PS file !! \n\n"
    let Msg = Msg."(".g:TKps2pdfConv." will not be called)\n\n"
    let RC = confirm(Msg, "&Ok")
    return 1
  endif

  return 0
endfunction

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKLaunchDVIviewer(...)
  if a:0 > 0
    let g:TeXfile = a:1
  elseif ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  let DVIfileName = fnamemodify(g:TeXfile, ":t:r").".dvi"
  if filereadable(DVIfileName)
    let ExeCmd= g:TKDVIviewer." ".DVIfileName
    if g:TKdetachedViewers
      let ExeCmd= g:TKviewerDetachedPre.ExeCmd.g:TKviewerDetachedPost 
    endif  
    exe  "!".ExeCmd
    echo "If fonts should be generated it may take a few seconds"
  else
    let RC=confirm(DVIfileName." is unreadable, make sure it exists", "&OK")
  endif
endfunction

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKLaunchPSviewer(...)
  if a:0 > 0
    let g:TeXfile = a:1
  elseif ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  let PSfileName = fnamemodify(g:TeXfile, ":t:r").".ps"
  if filereadable(PSfileName)
    let ExeCmd= g:TKPSviewer." ".PSfileName
    if g:TKdetachedViewers
      let ExeCmd= g:TKviewerDetachedPre.ExeCmd.g:TKviewerDetachedPost 
    endif  
    exe  "!".ExeCmd
  else
    let RC=confirm(PSfileName." is unreadable, make sure it exists", "&OK")
  endif
endfunction

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKLaunchPDFviewer(...)
  if a:0 > 0
    let g:TeXfile = a:1
  elseif ! exists("g:TeXfile")
    call TKSetTeXfileName()
  endif

  let PDFfileName = fnamemodify(g:TeXfile, ":t:r").".pdf"
  if filereadable(PDFfileName)
    let ExeCmd= g:TKPDFviewer." ".PDFfileName
    if g:TKdetachedViewers
      let ExeCmd= g:TKviewerDetachedPre.ExeCmd.g:TKviewerDetachedPost 
    endif  
    exe  "!".ExeCmd
  else
    let RC=confirm(PDFfileName." is unreadable, make sure it exists", "&OK")
  endif
endfunction


"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKsplitOpenLog()
  if ! exists("g:TeXfile")
    let g:TeXfile = bufname("%")
  endif
  let TeXfileBasename = fnamemodify(g:TeXfile, ":t:r")
  let TeXLogfileName = TeXfileBasename.".log"
  if filereadable(TeXLogfileName)
    execute "normal :split\<CR>:e ".TeXLogfileName."\<CR>"
  else
    let rc = confirm("Couldn't read log file (".TeXLogfileName.")","&OK")
  endif
endfunction

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKnumToYesNo(Val)
  if a:Val
    return "yes"
  else
    return "no"
  endif
endfunction
"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKQueryPreferences(Msg, PrefVarName)
  let Msg = a:Msg
  exe "let CurVal = ".a:PrefVarName
  let Msg = Msg."\n[current value is \"".TKnumToYesNo(CurVal)."\"]\n"
  let Msg = Msg."\nFor a permanent setting add to you vimrc file:\n"
  let Msg = Msg."let ".a:PrefVarName." = 1 (or = 0)\n"
  let RC = confirm(Msg, "&Yes\n&No", 2-CurVal)
  " 1 -> 1 , 2 -> 0
  exe "let ".a:PrefVarName." = 2 - RC"
endfunction
"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKSetPreferences()
  call TKQueryPreferences("Enable Hebrew ?\n", "g:TKenableHebrew")

  if g:TKenableHebrew 
    let Msg = "Separate languages on separate lines?\n"
    call TKQueryPreferences(Msg, "g:TKseparateLang")
  endif

  let Msg = "Put section labels on a separate line?\n" 
  call TKQueryPreferences(Msg, "g:TKlabelOnSepLine")

  let Msg = "Open viewers in detached sessions?\n"
  call TKQueryPreferences(Msg, "g:TKdetachedViewers")
endfunction

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKSetDefaultProgNames()
  if !has ("win32")
    "UNIX
    let g:TKrmCmd = "\\rm"
    let g:TKcpCmd = "\\cp -p"
    let g:TKlatexProg = "elatex"
    " scrollmode is nice, but for some errors latex will prompt you for an
    "input, and in some you'll even have to use ^C to terminate it
    "let g:TKlatexProg = "elatex --interaction scrollmode"
    let g:TKdvi2psProg = "dvips"
    let g:TKps2pdfConv = "ps2pdf"
    let g:TKDVIviewer = "xdvi"
    let g:TKPSviewer = "gv"
    let g:TKPDFviewer = "acroread"
    "let g:TKviewerDetachedPre = "xterm -sb -e "
    let g:TKviewerDetachedPre = "xterm -sb -iconic -e "
    let g:TKviewerDetachedPost = " &"
  else
    "Win32
    let g:TKrmCmd = "del"
    let g:TKcpCmd = "copy"
    let g:TKlatexProg = "latex"
    let g:TKdvi2psProg = "dvips"
    let g:TKps2pdfConv = "ps2pdf"
    let g:TKDVIviewer = "yap"
    let g:TKPSviewer = "gsview32"
    let g:TKPDFviewer = "acrord32"
    let g:TKviewerDetachedPre = "start "
    let g:TKviewerDetachedPost = ""
  endif
endfunction
  
  
"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKSetProgNames()
  echo "\n  NOTES: 1. You can set all preferences in your .vimrc file !! \n"
  echo "\n         2. Pressing ENTER will keep the current value "
  echo "\n            (Shown as [current value] in each prompt) \n\n"

  " Set name of LaTeX program
  if ! exists("g:TKlatexProg")
     let g:TKlatexProg = "latex"
  endif
  let InputPrompt= "\nEnter name of LaTeX program \[".g:TKlatexProg."\]\n"
  let EnteredValue= input(InputPrompt)
  if EnteredValue != ""
     let g:TKlatexProg = EnteredValue
  endif

 " Set name of DVI to PS converter
  if ! exists("g:")
     let g:TKdvi2psProg = "dvips"
  endif
  let InputPrompt= "\nEnter name of DVI to PS converter \[".g:TKdvi2psProg."\]\n"
  let EnteredValue= input(InputPrompt)
  if EnteredValue != ""
     let g:TKdvi2psProg = EnteredValue
  endif



  " Set name of PS to PDF converter
  if ! exists("g:TKps2pdfConv")
     let g:TKps2pdfConv = "ps2pdf"
  endif
  let InputPrompt= "\nEnter name of PS to PDF converter \[".g:TKps2pdfConv."\]\n"
  let EnteredValue= input(InputPrompt)
  if EnteredValue != ""
     let g:TKps2pdfConv = EnteredValue
  endif


  " Set name of DVI viewer
  if ! exists("g:TKDVIviewer")
     if has ("win32")
        let g:TKDVIviewer = "yap"
     else
        let g:TKDVIviewer = "xdvi"
     endif
  endif
  let InputPrompt= "\nEnter name of DVI viewer \[".g:TKDVIviewer."\]\n"
  let EnteredValue= input(InputPrompt)
  if EnteredValue != ""
     let g:TKDVIviewer = EnteredValue
  endif

  " Set name of PS viewer
  if ! exists("g:TKPSviewer")
     if has ("win32")
        let g:TKPSviewer = "gsview32"
     else
        let g:TKPSviewer = "gv"
     endif
  endif
  let InputPrompt= "\nEnter name of postscript viewer \[".g:TKPSviewer."\]\n"
  let EnteredValue= input(InputPrompt)
  if EnteredValue != ""
     let g:TKPSviewer = EnteredValue
  endif

  " Set name of PDF viewer
  if ! exists("g:TKPDFviewer")
     if has ("win32")
        let g:TKPDFviewer = "acrord32"
     else
        let g:TKPDFviewer = "acroread"
     endif
  endif
  let InputPrompt= "\nEnter name of PDF viewer \[".g:TKPDFviewer."\]\n"
  let EnteredValue= input(InputPrompt)
  if EnteredValue != ""
     let g:TKPDFviewer = EnteredValue
  endif

endfunction


"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKusageHelp()
  echo "\n  Latex environment for GVIM   [ Version 0.25 --  1 March 1999 ]\n\n"
  echo "  LaTeX only    - runs LaTeX once. \n"
  echo "  Run LaTeX once- runs LaTeX makeindex and BibTeX once. \n"
  echo "  Make DVI file - runs LaTeX, makeindex and BibTeX enough times to \n"
  echo "                  solve references, citations etc.\n"
  echo "  Make PS file  - create postscript file from the dvi file, tries\n"
  echo "                  to create the DVI file if it's missing.\n"
  echo "  Make PDF file - create PDF file from the postscript file, tries\n"
  echo "                  to create the PS file if it's missing.\n"
  echo "  Set Main Tex file name - allows to set the name of the TeX file\n"
  echo "                  on which the following commands are executed.\n"
  echo "                  E.g. if you edit a file that is included by the\n"
  echo "                  main TeX file.\n"
  echo "  View DVI file\n"
  echo "  View PS file\n"
  echo "  View PDF file - call the appropriate viewer.\n"
  echo "  View Log file - open the log file in a split window.\n"
  echo "  Set preferences- Set the names of the programs called (E.g. view\n"
  echo "                   PDF using ghostview or Acrobat reader)\n"
  echo "                   and other preferences.\n"
  echo "                   NOTE: applies to current session, for a permanenr\n"
  echo "                         change set it in the .vimrc file (see docs).\n"
  echo "  Help -           Show this help page.\n"
  echo "  ispell this buffer- run ispell on the current buffer.\n"
  echo "                   (ispell should be available on the computer)\n"
  echo "  Create New document- lets you create a skelaton for a new LaTeX"
  echo "                   document."
  echo "  Load a template - lets you load a template you've prepared."
  echo " \n\n                              Tomer Kol\n\n"

  let RC = input("Press ENTER to continue")
endfunction



"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKSetTitle()
  if expand("%:e") == "tex" && exists("g:TeXfile")
    let &titlestring = "VIM@".hostname()."  - Edited file: ".expand("%:~")
    let &titlestring = &titlestring ."        Main TeX File: ".g:TeXfile"
  else
    let &titlestring = "VIM@".hostname()."  - ".expand("%:~")
  endif
endfunction

"+-----------------------------------------------------+
"|                                                     |
"| Setup the menus                                     |
"| add args?                                                |
"| where to put the latex menu, where to put the       |
"| language menu                                       |
"+-----------------------------------------------------+
function! TKsetDefaultMenu()
  
  " Make sure the '<' flag is not included in 'cpoptions', otherwise <CR> would
  " not be recognized.  See ":help 'cpoptions'".
  let cpo_save = &cpo
  let &cpo = ""

""""""""""""""""""""""""""""""""""""""""""""""""
" Additions for Hebrew and LaTeX               "
""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""
" file menu
amenu 10.315 &File.&Open\ new\ TeX\ document	:browse confirm e<CR>:call TKSetTeXfileName()<CR>

"""""""""""""
"latex menu
nmenu 150.303 &LaTeX.LaTex\ &only :wa<CR>:call TKLatexOnly() <CR><CR>
imenu 150.303 &LaTeX.LaTex\ &only <ESC>:wa<CR>:call TKLatexOnly() <CR><CR>
nmenu 150.305 &LaTeX.Run\ &LaTex\ once :wa<CR>:call TKMakeDVIfile(1) <CR><CR>
imenu 150.305 &LaTeX.Run\ &LaTex\ once <ESC>:wa<CR>:call TKMakeDVIfile(1)<CR><CR>
nmenu 150.310 &LaTeX.Make\ &DVI		:wa<CR>:call TKMakeDVIfile() <CR><CR>
imenu 150.310 &LaTeX.Make\ &DVI		<ESC>:wa<CR>:call TKMakeDVIfile() <CR><CR>
nmenu 150.320 &LaTeX.Make\ &PS		:wa<CR>:call TKMakePSfile() <CR><CR>
imenu 150.320 &LaTeX.Make\ &PS		<ESC>:wa<CR>:call TKMakePSfile() <CR><CR>
nmenu 150.330 &LaTeX.Make\ PDF		:wa<CR>:call TKMakePDFfile() <CR><CR>
imenu 150.330 &LaTeX.Make\ PDF		<ESC>:wa<CR>:call TKMakePDFfile() <CR><CR>
amenu 150.340 &LaTeX.Set\ Main\ TeX\ file\ name	:call TKSetTeXfileName(1) <CR>
amenu 150.345 &LaTeX.--------------------		<C-L>
amenu 150.350 &LaTeX.&view\ DVI\ file	:call TKLaunchDVIviewer() <CR><CR>
amenu 150.360 &LaTeX.view\ PS\ file	:call TKLaunchPSviewer() <CR><CR>
amenu 150.370 &LaTeX.view\ PDF\ file	:call TKLaunchPDFviewer() <CR><CR>
amenu 150.375 &LaTeX.view\ Log\ file 	:call TKsplitOpenLog() <CR><CR>
amenu 150.380 &LaTeX.---------------------	<C-L>
amenu 150.390 &LaTeX.Set\ Preferences.Programs\ names	:call TKSetProgNames() <CR>
amenu 150.390 &LaTeX.Set\ Preferences.Other\ preferences :call TKSetPreferences()<CR>
amenu 150.395 &LaTeX.&Help			:call TKusageHelp() <CR>
amenu 150.400 &LaTeX.----------------------	<C-L>
if !has ("win32")
nmenu 150.400 &LaTeX.ispell\ this\ buffer   	:w<CR>:!xterm -e ispell %<CR>:e %<CR><CR>
imenu 150.400 &LaTeX.ispell\ this\ buffer   	<ESC>:w<CR>:!xterm -e ispell %<CR>:e %<CR><CR>
else
nmenu 150.400 &LaTeX.ispell\ this\ buffer   	:w<CR>:!ispell %<CR>:e %<CR><CR>
imenu 150.400 &LaTeX.ispell\ this\ buffer   	<ESC>:w<CR>:!ispell %<CR>:e %<CR><CR>
endif
amenu 150.410 &LaTeX.======================	<C-L>
amenu 150.420 &LaTeX.Create\ New\ Document	:call TKcreateLaTeXTemplate()<CR>
amenu 150.430 &LaTeX.Load\ a\ template		:call TKloadTemplate()<CR>
amenu 150.440 &LaTeX.-====================-	<C-L>
amenu 150.440 &LaTeX.About			:call TKversion()<CR>


if (g:TKenableHebrew)
"Hebrew menu
"160amenu Language.Hebrew-English\ <F9>	<F9>
imenu 160.310 Language.Hebrew-English<Tab>F9	<Esc>:set invrl<CR>:set invhk<CR>
nmenu 160.310 Language.Hebrew-English<Tab>F9	:set invrl<CR>:set invhk<CR>
endif " if (g:TKenableHebrew)

  let &cpo = cpo_save
  unlet cpo_save
endfunction

"+-----------------------------------------------------+
"|                                                     |
"| key bindings mappings                               |
"|                                                     |
"+-----------------------------------------------------+
function! TKsetdefaultKeys()

  """""""""""""""""""""""""""""""""""""""
  " LaTeX mode commands
  """""""""""""""""""""""""""""""""""""""
  map  <C-l><C-s>  :call TKinsertSec()<CR>
  imap <C-l><C-s>  <Esc>:call TKinsertSec()<CR>
  map  <C-l><S-s>  :call TKinsertSec()<CR>
  imap <C-l><S-s>  <Esc>:call TKinsertSec()<CR>

  "insert latex env
  map  <C-l><C-e>  :call TKinsertEnv()<CR>
  imap <C-l><C-e>  <Esc>:call TKinsertEnv()<CR>

  "insert latex env protected in an English env
  map  <C-l><S-e>  :call TKinsertEnv(1)<CR>
  imap <C-l><S-e>  <Esc>:call TKinsertEnv(1)<CR>

  map  <C-l><C-f>  :call TKinsertFloat()<CR>
  imap <C-l><C-f>  <Esc>:call TKinsertFloat()<CR>

  map  <C-l><C-r>  :call TKenterCmdWithText()<CR>
  imap <C-l><C-r>  <Esc>:call TKenterCmdWithText()<CR>

  map  <C-l><C-i>  :call TKotherLangInsert()<CR>i
  imap <C-l><C-i>  <Esc>:call TKotherLangInsert()<CR>i

  map  <C-l><C-g>  :call TKincludegraphics()<CR>
  imap <C-l><C-g>  <Esc>:call TKincludegraphics()<CR>

  map  <C-l><C-d>  :wa<CR>:call TKMakeDVIfile()<CR><CR>
  imap <C-l><C-d>  <Esc>:wa<CR>:call TKMakeDVIfile()<CR><CR>

  map  <C-l><C-o>  :wa<CR>:call TKMakeDVIfile(1)<CR><CR>
  imap <C-l><C-o>  <Esc>:wa<CR>:call TKMakeDVIfile(1)<CR><CR>


  " insert \item on a new line
  map  <C-l><CR>   o\item<SPACE>
  imap <C-l><CR>   <Esc>o\item<SPACE>

if (g:TKenableHebrew)
  """""""""""""""""""""""""""""""""""""""""""""
  " Control-ENTER
  "Open new line switching Language
  map <C-CR> :set invrl<CR>:set invhk<CR>o
  imap <C-CR> <Esc>:set invrl<CR>:set invhk<CR>o

  " Shift-ENTER
  "Split current line at point, placing a line in the other language
  map <S-CR> a<CR><ESC>:set invrl<CR>:set invhk<CR>O
  imap <S-CR> <Esc>a<CR><ESC>:set invrl<CR>:set invhk<CR>O

  " Shift-Control-ENTER
  " make an insert of the other language
  imap <S-C-CR> <ESC>:call TKotherLangInsert()<CR>i

  " Shift-END
  " go to end of line, switching language
  map <S-END>   :set invrl<CR>:set invhk<CR>A
  imap <S-END>  <Esc>:set invrl<CR>:set invhk<CR>A
  """""""""""""""""""""""""""""""""""""""""""""

  " Function keys

  """""""""""""""""""""""""""""""""""""""""""""
  " toggle both direction and hebrew keyboard mapping
  map <F9>   :set invrl<CR>:set invhk<CR>
  " do it when in insert mode as well (and return to insert mode)
  imap <F9> <Esc>:set invrl<CR>:set invhk<CR>a
  "toggle comand line language
  cmap  <S-F9>  <C-_>
  " toggale language and add at EOL (useful after CLCI use CLCB instead?)
  map <C-F9>   :set invrl<CR>:set invhk<CR>
  " do it when in insert mode as well (and return to insert mode)
  imap <C-F9> <Esc>:set invrl<CR>:set invhk<CR>A
  """""""""""""""""""""""""""""""""""""""""""""
endif


endfunction



"#################################################################
"+=====================================================+
"|                                                     |
"|   Functions for the support of editing LaTeX        |
"|                                                     |
"+=====================================================+

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKinsertSec()

  let ConfPrompt="Type of section to enter:"
  let ConfChoices="&Chapter\n&Section\nS&ubsection\nSu&bsubsection\n&Paragraph"
  let ConfChoices=ConfChoices."\nCANCEL"
  let choice = confirm(ConfPrompt, ConfChoices, 2)
  if     choice == 1
    let SecType = "chapter"
  elseif choice == 2
    let SecType = "section"
  elseif choice == 3
    let SecType = "subsection"
  elseif choice == 4
    let SecType = "subsubsection"
  elseif choice == 5
    let SecType = "paragraph"
  elseif choice == 6
    return
  endif

  let SecName = input("name of ".SecType.": ")
  if  g:TKenableHebrew  && g:TKseparateLang  &&  &rl
    let SecCommand =  "\\".SecType."{%\n".SecName."%\n}"
  else
    let SecCommand =  "\\".SecType."{".SecName."}"
  endif
  let Text =  "%=====================\n"
  let Text =  Text.SecCommand

  let LabelName = input("Enter label (just press <ENTER> for none): ")
  if LabelName != ""
    if g:TKlabelOnSepLine
      let Text = Text."\n\\label{".LabelName."}"
    else
      let Text = Text."\\label{".LabelName."}"
    endif
  endif

  exe "normal o".Text."\n\<esc>"
endfunction

"+-----------------------------------------------------+
"| optional parameter - place in an English environment|
"+-----------------------------------------------------+
function! TKinsertEnv(...)
  let EnvName = input("name of Environment: ")
  " save current content
  let Text = "\\begin{".EnvName."}\n\n\\end{".EnvName."}"

  " if at beginning of line - start in current line. If not - open 
  " a new line for the \begin{}
  if col(".") != 1
    exe "normal o\<esc>"
  endif

  let LineAdj = "-1"
  if a:0 != 0
    if a:1 && g:TKenableHebrew
      let Text = "\\begin{otherlanguage}{english}\n".Text
      let Text = Text."\n\\end{otherlanguage}"
      let LineAdj = "-2"
      "if we protect this in an English environment, we might 
      " as well make sure we're in left-right mode
      exe "set norl"
      exe "set nohk"
    endif
  endif

  exe "normal i".Text."\<esc>"
  " move up
  exe LineAdj
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"+-----------------------------------------------------+
"|  insert ref/cite/caption etc.                       |
"|  argument (optional) is the type of cmd             |
"+-----------------------------------------------------+
function! TKenterCmdWithText(...)
  if a:0 == 0
    let LinkType = input("name of link (ref, label etc.): ")
  else
    let LinkType = a:1
  endif
  let LinkLabel = input("label/text for the link: ")

  if  g:TKenableHebrew  && g:TKseparateLang &&  &rl
    if col(".") == 1
      let Text = "\\".LinkType."{%\n".LinkLabel."%\n}%\n"
    else
      let Text = "%\n\\".LinkType."{%\n".LinkLabel."%\n}%\n"
    endif
  else
    let Text = "\\".LinkType."{".LinkLabel."}"
  endif

  exe "normal a".Text."\<esc>"
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKotherLangInsert()
  if &rl == 1
    let InsertCmd = "\\L"
  else
    let InsertCmd = "\\R"
  endif

  if  g:TKenableHebrew  && g:TKseparateLang
    if col(".") == 1
      let Text = InsertCmd."{}"
    else
      let Text = "\n".InsertCmd."{}"
    endif

"    let Text = "\n".InsertCmd."{}"
    exe "normal a".Text."\<esc>"
  else
    let Text = InsertCmd."{}"
    exe "normal a".Text."\<esc>"
  endif

  exe "set invrl"
  exe "set invhk"
endfunction

"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKincludegraphics()
  "enlarge cmdheight
  let OrigCH = &ch
  let &ch = 4
  let FileName = input("name of graphics file: ")
  echo  "\nEnter parameters (scaling etc.) just press <ENTER> for none:\n"
  let &ch = OrigCH
  let Inputtext = ""
  let Params = input(Inputtext)
  if Params != ""
    let CmdText = "\\includegraphics[".Params."]{".FileName."}"
  else
    let CmdText = "\\includegraphics{".FileName."}"
  endif

  if  g:TKenableHebrew
    let Text = "\\begin{otherlanguage}{english}\n  ".CmdText
    let Text = Text."\n\\end{otherlanguage}\n"
  else
    let Text = CmdText."\n"
  endif

  exe "normal a".Text."\<esc>"
endfunction


"+-----------------------------------------------------+
"|                                                     |
"+-----------------------------------------------------+
function! TKinsertFloat()
  "enlarge cmdheight
  let OrigCH = &ch
  let &ch = 6
  let FloatName = input("name of float (figure, table ...): ")
  let CRforNone = "(press <ENTER> for none): "
  let FloatPlac = input("\nEnter placement ".CRforNone)
  let FloatCap = input("\nEnter caption ".CRforNone."\n")
  let FloatLabel = input("\nEnter label ".CRforNone."\n")
  
  if FloatPlac == ""
    let Text = "\\begin{".FloatName."}\n  \n"
  else
    let Text = "\\begin{".FloatName."}[".FloatPlac."]\n  \n"
  endif

  let LineAdj = "-2"

  if  FloatCap != ""
    let Text = Text."  \\caption{".FloatCap."}\n"
    let LineAdj = LineAdj - 1
  endif
  if FloatLabel  != ""
    let Text = Text."  \\label{".FloatLabel."}\n"
    let LineAdj = LineAdj - 1
  endif
  
  let Text = Text."\\end{".FloatName."}\n"
 
  " if at beginning of line - start in current line. If not - open 
  " a new line for the \begin{}
  if col(".") != 1
    exe "normal o\<esc>"
  endif

  exe "normal i".Text."\<esc>"
  " move up
  exe LineAdj

  let &ch = OrigCH
endfunction

"+-----------------------------------------------------+
"| TKloadTemplate()                                    |
"|                                                     |
"|                                                     |
"+-----------------------------------------------------+
function! TKloadTemplate()
"  exe "normal :so $VIM\<tab>\<esc>"
  if !exists("g:TKtemplatesDir")
    let Msg = "ERROR: \"TKtemplatesDir\" is not defined!!\n\n"
    let Msg = Msg."NOTE: You should set TKtemplatesDir in your vimrc file,\n"
    let Msg = Msg."      e.g., by adding the line:\n"
    let Msg = Msg."let TKtemplatesDir=\"~/TeX/Templates/\"\non unix, or\n"
    let Msg = Msg."let TKtemplatesDir=\"C:\\\\TeX\\\\Templates\\\\\" \non windows"
    let Msg = Msg."\n\nI can try $VIM/Templates/"
    let RC = confirm(Msg, "Try it\n&Abort")
    if RC == 1
      exe "browse confirm e $VIM/Templates/"
    else
      return
    endif
  else
    exe "browse confirm e ".g:TKtemplatesDir
  endif
  " we should now save the template under a different name
  let Msg = "You should save the template using another name"
  let NewName = browse(1,Msg, getcwd()."/", "newfile.tex")
  if NewName != ""
    if fnamemodify(NewName, ":e") != "tex"
      let NewName = NewName.".tex"
    endif
    if filereadable(NewName)
      let Msg = "The file \"".NewName."\" already exists.\nOverwrite?" 
      let RC = confirm(Msg, "&Yes\n&Cancel", 2)
      if RC == 2
        return
      endif
    endif

    exe ":w! ".NewName
    exe ":e ".NewName
  else
    let Msg = "You did not save the template file under a new name.\n"
    let Msg = Msg."I suggest you do it unless you intend to change \n"
    let Msg = Msg."the template"
    let RC = confirm(Msg, "&OK\n&Cancel", 2)
    if RC == 2
      return
    endif
  endif

  call TKSetTeXfileName(1)
endfunction


"+-----------------------------------------------------+
"| TKcreateLaTeXTemplate()                             |
"|                                                     |
"|                                                     |
"+-----------------------------------------------------+
  " TODO
  " add \maketitle et al
  "
function! TKcreateLaTeXTemplate()
  let CurBufName = bufname("%")
  let FileName=input("\nEnter file name [".CurBufName."]: ")
  if FileName == ""
    if CurBufName != ""
      let FileName = CurBufName
    else
      echo "No file name was entered!!"
      return
    endif
  endif
  "if extension is not tex, add .tex
  if fnamemodify(FileName, ":e") != "tex"
    let FileName = FileName.".tex"
  endif
  if filereadable(FileName)
    let Msg = "The file \"".FileName."\" already exists.\nOverwrite?" 
    let RC = confirm(Msg, "&Yes\n&Cancel", 2)
    if RC == 2
      return
    endif
  endif
  exe "wa"
  exe "e! ".FileName
  exe "1,$d"
  
  if g:TKdefDocClass != ""
    let Msg = "Your default document class is: ".g:TKdefDocClass
    let Msg = Msg."\nWith the options: ".g:TKdefDocOpt
    let RC = confirm(Msg, "&Use it\n&Change it\n&Abort", 1)
  else
    RC = 2
  endif
  if RC == 3
    return 1
  endif
  if  RC == 1
    let DocClass = g:TKdefDocClass
    let ClassArgs = g:TKdefDocOpt
  else
    let Msg = "\n What class of document would you like?\n"
    let Msg=Msg." E.g., article, report, book etc.  "
    let DocClass = input(Msg)
    let Msg="\n".Msg."\n ERROR!! (empty string is not valid, \"article\" is "
    let Msg=Msg."a good default): "
    while DocClass == ""
      let DocClass = input(Msg)
    endwhile

    let Msg = "\nEnter class options separated by commas\n"
    let Msg=Msg." E.g., if you use  A4 paper add \"a4paper\"\n"
    let Msg=Msg."       to get  larger font add \"11pt\" or \"12pt\"\n"
    let ClassArgs = input(Msg)
  endif
  let Msg = "Query about optional packages and features or just put everything?\n\n"
  let Msg = Msg."(i.e., graphicx, hyperref, index, table of contents and \n"
  let Msg = Msg."(only if TKenableHebrew is set) Hebrew (with hebrew as\n"
  let Msg = Msg." the default language)\n"
  let RC = confirm(Msg, "Put &everthing in\n&Let me choose\n&Abort", 2)
  if RC == 3
    return 1
  endif

  if RC == 2
    let Msg = "Do you need the \"graphixs\" package?\n(needed to include"
    let Msg = Msg." eps figures, color text etc."
    let PkgGraphicx = confirm(Msg, "&Yes\n&No")

    let Msg = "Do you need the \"hyperref\" package?\n(needed to create"
    let Msg = Msg."hyperlink (e.g., for PDF output)"
    let PkgHyperref = confirm(Msg, "&Yes\n&No")

    " conditioned by the value of enable Hebrew
    if g:TKenableHebrew
      let Msg = "Will this document include Hebrew?"
      let PkgHebrew = confirm(Msg, "&Yes\n&No")
      if  PkgHebrew == 1
        let Msg = "What will be the main language?"
        let MainLangHeb = confirm(Msg, "&Hebrew\n&English")
      endif
    else
      let PkgHebrew = 0
    endif

    let Msg = "Will this document contain an index?"
    let PkgIdx = confirm(Msg, "&Yes\n&No")

    let Msg = "Would you like a table of contents?"
    let WantTOC = confirm(Msg, "&Yes\n&No")
  else
    let PkgGraphicx = 1
    let PkgHyperref = 1
    let PkgHebrew = g:TKenableHebrew
    let MainLangHeb = g:TKMainLangHebrew
    let PkgIdx = 1
    let WantTOC = 1
  endif


  "------------------------------------
  "  create the document's skeleton
  "------------------------------------
  call TKinsertline("%+====================================+")
  call TKinsertline("%|     Skeleton created by TKlatex    |")
  call TKinsertline("%+====================================+")
  if ClassArgs == ""
    call TKinsertline("\\documentclass{".DocClass."}")
  else
    call TKinsertline("\\documentclass[".ClassArgs."]{".DocClass."}")
  endif

  call TKinsertline("%+----------------+")
  call TKinsertline("%|    Packages    |")
  call TKinsertline("%+----------------+")

  if PkgGraphicx == 1
    call TKinsertline("\\usepackage{graphicx}")
  endif
  
  if PkgIdx == 1
    call TKinsertline("\\usepackage{makeidx}")
    call TKinsertline("\\makeindex")
  endif

  if PkgHebrew == 1
    if  MainLangHeb == 1
      call TKinsertline("\\usepackage[english,hebrew]{babel}")
    else
      call TKinsertline("\\usepackage[hebrew,english]{babel}")
    endif
  endif

  if PkgHyperref == 1
    call TKinsertline("% Hyperref is configured for PS and PDF files.")
    call TKinsertline("% To get hyperlinked DVI remove the \"dvips\" option")
    call TKinsertline("% of hyperref")
    call TKinsertline("\\usepackage[dvips,colorlinks,breaklinks]{hyperref}")
  endif
  
  if PkgHebrew == 1
    call TKinsertline("% TKfixes should be the last package")
    call TKinsertline("\\usepackage{TKfixes}")
  endif
  call TKinsertline("")
  call TKinsertline("")
  call TKinsertline("%+====================================+")
  call TKinsertline("%|        Doc content !!              |")
  call TKinsertline("%+====================================+")
  call TKinsertline("\\begin{document}")
  if WantTOC == 1
    call TKinsertline("")
    call TKinsertline("\\tableofcontents")
  endif
  
  call TKinsertline("")
  call TKinsertline("")
  call TKinsertline("")
  
  if PkgIdx == 1
    call TKinsertline("%next command includes the index")
    call TKinsertline("\\printindex")
  endif
  call TKinsertline("\\end{document}")
  call TKinsertline("")
  
  exe "-5"
  let Msg = "File created.\nLook at the comments in the created file\n"
  let Msg = Msg."Next you'll get an option to set the main TeX file to the \n"
  let Msg = Msg."newly created file (this is probably what you should do)\n"
  let RC = confirm(Msg, "&Thanks")

  call TKSetTeXfileName(1)

  return 0
endfunction



"+=====================================================+
"|                                                     |
"|                 Initialization                      |
"|                                                     |
"+=====================================================+


"Set title
if !exists("TKtitleAU")
  let g:TKtitleAU = 1
  
  auto BufEnter * call TKSetTitle()

endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1-> enable Hebrew features
if !exists("TKenableHebrew")
  let g:TKenableHebrew = 0
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1-> Primary document's language is Hebrew
if !exists("TKMainLangHebrew")
  let g:TKMainLangHebrew = g:TKenableHebrew
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1 -> seperate hebrew and english in commands
if !exists("TKseparateLang")
  let g:TKseparateLang = g:TKenableHebrew
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1-> put \label{} of sections on a new line
if !exists("TKlabelOnSepLine")
  let g:TKlabelOnSepLine = 1
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start (DVI/PS/PDF) viewers detached
if !exists("TKdetachedViewers")
  let g:TKdetachedViewers = 1
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default doc type
if !exists("TKdefDocClass")
  let g:TKdefDocClass = "article"
endif
if !exists("TKdefDocOpt")
  let g:TKdefDocOpt = "a4paper,12pt"
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""
call TKSetDefaultProgNames()
