" Get vimfiles installation directory (usually '~/vimfiles' or '~/.vim').
" This allows vimfiles to be placed in a path other than the default.
let $VIMHOME = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" Put vimfiles into the runtimepath list. This is required to make ftdetect
" and ftplugin files to be properly loaded.
set runtimepath+=$VIMHOME

" turn off vi compatibility mode
if !has('nvim')
  set nocompatible
end

" Fish shell is not POSIX compatible. Because of that, there are some issues
" with it and VIM < 7.4.276. The solution is to use sh if VIM was invoked by a
" fish shell.
if v:version < 704 || v:version == 704 && !has('patch276')
  if &shell =~# 'fish$'
    set shell=/bin/sh
  endif
end

" plugins managed by vim-plug
call plug#begin("$VIMHOME/plugged")

if executable('fzf')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
else
  echom 'fzf executable not found. Install it with "brew install fzf".'
endif

Plug 'dag/vim-fish'
Plug 'ervandew/supertab'
Plug 'mileszs/ack.vim'
Plug 'nginx.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sjl/badwolf'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
call plug#end()

" Turn filetype detection, indent scripts and filetype plugins on. This makes
" ftdetect and ftplugin scripts to be loaded.
filetype plugin indent on

" global settings
set clipboard=unnamed " use system clipboard
set title " show the current filename on the window title

" encoding
set encoding=utf-8 " sets how vim represents strings internally
set fileencoding=utf-8 " sets the encoding used to write files

" editor
set backspace=eol,start,indent " allow backspacing over everything in insert mode
if exists('&esckeys') " this feature was removed from neovim
  set noesckeys " <esc> is recognized immediately
endif
set nrformats-=octal " ignore octal numbers when increment with ctrl-a/x
set textwidth=0 " disable auto line break
set virtualedit=onemore " allow the cursor to move just past the end of the line

" navigation and UI
set colorcolumn=100 " show a column on screen that is useful to align text
set completeopt=menuone,preview
set fillchars+=vert:\ " set an empty space as window separator
set lazyredraw " screen will not be redrawn while executing macros
set list " show all characters
set listchars=tab:→→,trail:·,nbsp:_,eol:¬ " show tabs and trailing spaces
set mouse= " disable mouse support
set nostartofline " keep the cursor on the same column when moving around
set nowrap " disable automatic word wrapping
set number " show line numbers
set scrolloff=5 " minimum number of screen lines above and below the cursor
set showmatch " show matching parenthesis
set sidescrolloff=5 " minimum number of screen columns to keep to the left and to the right of the cursor
set showtabline=2 " always show tabline

" buffers and windows
set autoread " automatically reload file on change
set hidden " allow buffer switching without saving
set splitbelow " put new windows below the current one
set splitright " put new windows right of the current one

" modeline setup
set exrc " enable per-directory .vimrc, .nvimrc and .exrc files
set modeline " respect commands in files
set modelines=5 " allow 5 lines of commands
set secure " disable unsafe commands

" backup and swap
set backup " turn on backup
set writebackup " make a backup before overwriting a file
set swapfile " turn on swap

" history and undo
set history=1000 " number of commands saved in the history list
set undolevels=1000 " number of undo levels
set undofile " persistent undo on

" temporary files
" double slashes "//" at the end of directory means that file names will be
" built using the complete path
set backupdir=$VIMHOME/tmp/backup// " directory for backup files
set directory=$VIMHOME/tmp/swap// " directory for swap files
set undodir=$VIMHOME/tmp/undo// " directory for undo files

function! EnsureDirExists(dirname)
  if !isdirectory(a:dirname)
    call mkdir(a:dirname, 'p')
  endif
endfunction

call EnsureDirExists(&backupdir)
call EnsureDirExists(&directory)
call EnsureDirExists(&undodir)

" search
set gdefault " replace all by default
set hlsearch " highlight search
set ignorecase " ignore case when searching
set incsearch " show matches while typing
set smartcase " ignore case if search pattern is all lowercase

" tabs, spaces and indentation
set autoindent " copy indentation from the previous line
set copyindent " use the same chars used for indenting the previous line
set expandtab " convert tabs to spaces
set smarttab " uses shiftwidth instead of tabstop
set shiftwidth=2 " number of spaces to use for indentation
set softtabstop=2
set tabstop=2 " default tab size

" folds
set nofoldenable " open all folds by default
set foldlevel=20
set foldlevelstart=20
set foldmethod=indent " folding based on indentation

" statusline
set laststatus=2 " always show the status line
set statusline=
set statusline+=\ %{statusline#currentmode()}\  " current mode
set statusline+=%f " file name
set statusline+=%< " truncate line from here if it is too long
set statusline+=%{statusline#modified()} " modified flag
set statusline+=%{statusline#readonly()} " read only flag
set statusline+=%h " help buffer flag
set statusline+=%=
set statusline+=%{&fileformat}\  " file format
set statusline+=%{statusline#filetype()}\  " file type
set statusline+=%{&encoding}\  " file encoding
set statusline+=%l/%L\ %c\  " line and column number

" command line
set noshowmode " do not show current mode on command line
set noruler " do not show the cursor position on command line
set showcmd " show commands on status line
set wildmenu " enable autocomplete on command line
set wildmode=longest:full,full " complete longest common string and list alternatives

" annoying bells
set noerrorbells " disable error bells
set visualbell t_vb= " disable visual bells

" syntax highlight and colorscheme
syntax on
set background=dark
colorscheme badwolf " the color scheme (srsly)

" enable 24-bit color support if it is available
if has('termguicolors')
  set termguicolors
endif

" Automatically quit vim if NERDTree is last and only buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Mappings
let mapleader = '\' " use backslash as leader key

" show fzf window
nmap <leader><space> :Files<cr>
" save changes
nnoremap <leader>w :w<cr>
" sudo save changes
noremap <leader>W :w !sudo tee %<cr>
" quit the current window
nnoremap <leader>q :q<cr>
" toggle search highlight
nnoremap <silent> <leader>h :set invhlsearch<cr>
" toggle nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<cr>
" toggle gundo.vim
nnoremap <leader>u :GundoToggle<cr>
" search for files
nnoremap <leader>s :Ack!<space>
" open a new tab
nnoremap <silent> <leader>t :tabnew<cr>
" sort lines
vnoremap <leader>s :sort<cr>

" disable arrow keys for navigation
noremap <right> <nop>
noremap <left> <nop>
noremap <up> <nop>
noremap <down> <nop>

" disable arrow keys in the insert mode
inoremap <right> <nop>
inoremap <left> <nop>
inoremap <up> <nop>
inoremap <down> <nop>

" neovim terminal
if has('nvim')
  " use ESC to exit terminal
  tnoremap <esc> <c-\><c-n>
end

" ervandew/supertab
let g:SuperTabDefaultCompletionType = '<c-n>'

" scrooloose/nerdtree
let g:NERDTreeAutoDeleteBuffer = 1 " always remove a buffer when a file is being deleted or renamed
let g:NERDTreeMinimalUI = 1 " disables the 'Press ? for help' text
let g:NERDTreeShowHidden = 1 " display hidden files
let g:NERDTreeRespectWildIgnore = 1 " respect wildignore

" scrooloose/syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = 'x>'
let g:syntastic_loc_list_height = 5
let g:syntastic_warning_symbol = '!>'
