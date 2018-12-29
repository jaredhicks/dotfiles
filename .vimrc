
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize some things
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make Vim more useful
set nocompatible

" configure plugins with https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
call plug#end()

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']



" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif
" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Keep changes to the buffer if abandoned (why not a default?)
set hidden


" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Optimize for fast terminal connections
set ttyfast

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Enable line numbers
set number

" Highlight current line
set cursorline
"

" Disable error bells
set noerrorbells


" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Font and Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://stackoverflow.com/a/9833425
if $TERM == "xterm-256color"
    set t_Co=256
endif


" Use the Solarized Dark theme
set background=dark
if !has('gui_running')
    " Compatibility for Terminal
    let g:solarized_termtrans=1

    if (&t_Co >= 256 || $TERM == 'xterm-256color')
        " Not supposed to need this but whatevs:
        " https://stackoverflow.com/a/31606101
        let g:solarized_termcolors=256
    else
        " Make Solarized use 16 colors for Terminal support
        let g:solarized_termcolors=16
    endif
endif
colorscheme solarized

let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File handling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Don’t add empty newlines at the end of files
set binary
set noeol

" Respect modeline in files
set modeline
set modelines=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting -- General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" don't make it look like there are line breaks where there aren't:
set nowrap

" Match brackets/braces/parens
"set showmatch

""""""""""""" TAB/SPACE SETTINGS"""""""""""""""
"Default to copy the indentation of the previous line, but do not
"conflict with file-type-based indentation.
"This is overridden per filetype below
set autoindent

"The rest deal with whitespace handling and
"mainly make sure hardtabs are never entered
"as their interpretation is too non standard in my experience
set softtabstop=4
" Note if you don't set expandtab, vi will automatically merge
" runs of more than tabstop spaces into hardtabs. Clever but
" not what I usually want.
set expandtab
set shiftwidth=4
set shiftround
set nojoinspaces

" Show “invisible” characters
" (use :set list! to toggle visible whitespace on/off)
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" * Text Formatting -- Specific File Formats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ****** Note that any ftplugin settings will necessarily override
" ****** anything set here.

if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

  " for both CSS and HTML, use genuine tab characters for indentation,
  " to make files a few bytes smaller:
  autocmd FileType html,css set noexpandtab tabstop=2

  " in makefiles, don't expand tabs to spaces, since actual tab
  " characters are needed, and have indentation at 8 chars to be sure
  " that all indents are tabs (despite the mappings later):
  autocmd FileType make set noexpandtab shiftwidth=8

endif

"syntax highlight shell scripts as per POSIX,
"not the original Bourne shell which very few use
let g:is_posix = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" * Search & Replace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" Set the search scan to wrap around the file
set wrapscan

" Highlight matches by default
set hlsearch

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clipboard and mouse stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable mouse in all modes
set mouse=a

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes -- moving around
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don’t reset cursor to start of line when moving around.
set nostartofline

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
noremap <Space> <PageDown>
noremap <BS> <PageUp>
noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]

" scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>
" [<Ins> by default is like i, and <Del> like x.]


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" * Keystrokes -- Formatting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
"vmap <Tab> <C-T>
"vmap <S-Tab> <C-D>

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes -- Toggles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes -- Insert Mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Allow cursor keys in insert mode. Not sure if this is best but fine
" for now (https://www.johnhawthorn.com/2012/09/vi-escape-delays/)
set esckeys


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change mapleader
let mapleader=","

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
