" Debian system-wide default configuration Vim

set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim73,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start	" more powerful backspacing

filetype off
call pathogen#infect()
filetype on
filetype plugin indent on

syntax on
"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif
set nobackup		" do not keep a backup file, use versions instead
set history=1000	" keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch		" do incremental searching
set showmode        " Show current mode
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set showmatch		" Show matching brackets.
set incsearch		" Incremental search
set hlsearch
set autowrite       " Automatically save before commands like :next and make
set autoread        " auto read when file is changed from outside
set hidden          " Hide buffers when they are abandoned
set nowrap          " do not wrap lines
set autoindent		" always set autoindenting on
set cindent
set smartindent
set copyindent

" TAB setting{
    set tabstop=4
    set softtabstop=4 
    set expandtab        "replace <TAB> with spaces
    set shiftwidth=4
    set smarttab
    au FileType Makefile set noexpandtab
"}  

set fileformats="unix,dos,mac"

set pastetoggle=<F12>           " when in insert mode, press <F12> to go to
                                " paste mode, where you can paste mass data
								" that won't be autoindented

" modelines have historically been a source of security/resource
" vulnerabilities -- disable by default, even when 'nocompatible' is set
set nomodeline

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" We know xterm-debian is a color terminal
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Some Debian-specific things
if has("autocmd")
  " set mail filetype for reportbug's temp files
  augroup debian
    au BufRead reportbug-*		set ft=mail
  augroup END
endif

" Set paper size from /etc/papersize if available (Debian-specific)
if filereadable("/etc/papersize")
  let s:papersize = matchstr(readfile('/etc/papersize', '', 1), '\p*')
  if strlen(s:papersize)
    exe "set printoptions+=paper:" . s:papersize
  endif
endif

if has('gui_running')
  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

if executable("launchpad-integration")
  " Launchpad integration
  an 9999.76 &Help.Get\ Help\ Online\.\.\.             :call <SID>LPI("--info")<CR>
  an 9999.77 &Help.Translate\ This\ Application\.\.\.  :call <SID>LPI("--translate")<CR>
  an 9999.78 &Help.Report\ a\ Problem\.\.\.            :call <SID>LPI("--bugs")<CR>
  an 9999.79 &Help.-lpisep-                            <Nop>

  fun! s:LPI(opt)
    call system("launchpad-integration --pid " . getpid() . " " . a:opt)
  endfun
endif

set encoding=utf-8
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
"   set fileencodings=ucs-bom,utf-8,latin1
   set fileencodings=UTF-8,GBK,gb18030,gbk,big5,ucs-bom,cp936,euc-jp,euc-kr,iso8859-1
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

endif " has("autocmd")

"Doxygen
"let g:DoxygenToolkit_authorName="Dengbo boxdeng@gmail.com"
"let g:DoxygenToolkit_briefTag_funcName="yes"
"let g:DoxygenToolkit_enhanced_color=1
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
