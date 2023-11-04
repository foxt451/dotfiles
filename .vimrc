" general settings {{{
nnoremap <F3> :e $MYVIMRC<CR>
:nnoremap <F2> :buffers t<CR>:buffer<Space>
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649 (coc.nvim)
set nobackup
set nowritebackup
" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience (coc.nvim)
set updatetime=300
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved (coc.nvim)
set signcolumn=yes
set number
set relativenumber
set showcmd
syntax on
set re=0
set hidden
filetype plugin indent on
set ignorecase smartcase
set path+=**
set wildmenu
set scrolloff=5
set incsearch
" }}}

nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>f :Rg<CR>
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
" plugins {{{
call plug#begin()
Plug 'tpope/vim-eunuch'
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'
Plug 'github/copilot.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-obsession'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'simnalamburt/vim-mundo'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
call plug#end()
" }}}

" undo {{{
set undofile
set undodir=~/.vim/undo
nnoremap <F5> :MundoToggle<CR>
" }}}

" statusline {{{
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'catppuccin_macchiato',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead',
    \   'cocstatus': 'coc#status'
    \ },
    \ }
" }}}

" folds {{{
set foldlevelstart=99
set foldmethod=syntax
augroup foxt451_folding
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" upon sourcing vimrc, foldmethod will be reset to syntax, even if in vimrc
if &filetype == 'vim'
    set filetype=vim
endif
" }}}

" coc.nvim {{{
" Use <c-space> to trigger completion
inoremap <silent><expr> <c-@> coc#refresh()
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code
xmap <leader>p <Plug>(coc-format-selected)
nmap <leader>p <Plug>(coc-format-selected)
" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)
" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')
let g:coc_global_extensions = ['coc-json', 'coc-tsserver']
let g:coc_user_config = {}
let g:coc_user_config['coc.preferences.formatOnSaveFiletypes'] = ['*']

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" }}}

" copilot {{{
" avoid clashes with coc.nvim
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
" }}}

" colorscheme {{{
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
 let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
 let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors
set background=dark
colorscheme catppuccin_macchiato
highlight CocHighlightText ctermbg=DarkMagenta guibg=DarkMagenta
highlight CocHighlightText ctermfg=Grey guifg=Grey
" }}}

" netrw {{{
" let g:netrw_liststyle=3
let g:netrw_altfile = 1
" }}}

packadd! matchit

" terminal {{{
nnoremap <Leader>t :vertical botright term ++close<cr>
tnoremap <Leader>t <c-w>:vertical botright term ++close<cr>
" }}}
