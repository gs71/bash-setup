" Get the defaults that most users want.
"source $VIMRUNTIME/defaults.vim

" https://github.com/mhinz/vim-galore

" Load system defaults
if filereadable("/etc/vim/vimrc")
  source /etc/vim/vimrc
endif
if filereadable("/etc/vimrc")
  source /etc/vimrc
endif

set background=dark " Dark background terminal

filetype plugin indent on  " Load plugins according to detected filetype
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

"set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:·'
else
  let &listchars = 'tab:»·,extends:»,precedes:<,nbsp:·,trail:·'
  " let &listchars = 'tab:»·,trail:·,nbsp:·'
endif

set number          " Show line numbers
set linebreak       " Break lines at word (requires Wrap lines)
set showbreak=+++   " Wrap-broken line prefix
set textwidth=100   " Line wrap (number of cols)
set showmatch       " Highlight matching brace
set errorbells      " Beep or flash screen on errors
set visualbell      " Use visual bell (no beeping)
set smartcase       " Enable smart-case search
set ignorecase      " Always case-insensitive
set paste           " Turn off autoindent when pasting
set smartindent     " Enable smart-indent
set undolevels=2000 " Number of undo levels

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
 set mouse=a
endif

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" virtual tabstops using spaces
let my_tab=4

" allow toggling between local and default mode
function! TabToggle()
  if &expandtab
    set noexpandtab
    set shiftwidth=8
    set softtabstop=0
  else
    set expandtab
    execute "set shiftwidth=".g:my_tab
    execute "set softtabstop=".g:my_tab
  endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

" Use Tabs instead of Spaces
function! UseTabs()
  set noexpandtab   " Always uses tabs instead of space characters
  set tabstop=8     " Size of a hard tabstop
  set shiftwidth=8  " Size of an indentation
endfunction

" Use Spaces instead of Spaces
" if you want to enter a real tab character use Ctrl-V<Tab> key sequence
function! UseSpaces()
  set expandtab     " Always uses spaces instead of tab characters
  set tabstop=8     " Size of a hard tabstop
  execute "set shiftwidth=".g:my_tab
  execute "set softtabstop=".g:my_tab
  set shiftround    " >> indents to next multiple of 'shiftwidth'
  set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).
endfunction

execute UseSpaces()

au! BufWrite,FileWritePre *.php,*.js,*.css,*.cgi call UseSpaces()

" https://gist.github.com/moqmar/28dde796bb924dd6bfb1eafbe0d265e8
" Type :W (or :WQ respectively) to save a file using sudo
command W :execute ':silent w !sudo tee % > /dev/null' | :if v:shell_error | :edit! | :endif
