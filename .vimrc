" The .vimrc file!
" For more information, refer to
" https://www.cs.oberlin.edu/~kuperman/help/vim
" set nocompatible
if !has("nvim")
    source $VIMRUNTIME/defaults.vim
endif

filetype on
filetype plugin on
filetype plugin indent on

colo industry


" UltiSnips configuration
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"
let g:vimtex_fold_manual=1
let g:vimtex_matchparen_enabled = 0
let g:vimtex_view_automatic=0
let g:vimtex_syntax_custom_cmds = [
            \ {'name': 'bE', 'mathmode': 1, 'concealchar': '𝔼'},
            \ {'name': 'bR', 'mathmode': 1, 'concealchar': 'ℝ'},
            \ {'name': 'Prob', 'mathmode': 1, 'concealchar': 'ℙ'},
            \ {'name': 'bP', 'mathmode': 1, 'concealchar': 'ℙ'},
            \ {'name': 'justf', 'mathmode': 1, 'argstyle': 'ital', 'conceal': 1},
            \ {'name': 'difftl', 'mathmode': 1, 'concealchar': 'd'},
            \ ]
let g:vimtex_compiler_engine = 'lualatex'

" Disable custom warnings based on regexp
let g:vimtex_quickfix_ignore_filters = [
      \ 'Font Warning: Font shape.*using',
      \]

" Set indentation!
set tabstop=4    " Tabs are 4 chars wide
set autoindent   " Please, autoindent.
set smartindent  " Smart indentation. Does things based on keywords.
" set cindent      " If writing a c program -- stricter rules.
set shiftwidth=4 " Indent with 4 spaces.
set expandtab
set pastetoggle=<f5> " When pasting, don't indent. F5 toggles this.
set mouse=a
set nu " Show line numbers.
set conceallevel=2

syntax enable
filetype plugin indent on

autocmd BufNewFile,BufRead *.dart set syntax=javascript
autocmd BufNewFile,BufRead *.toml set syntax=desktop
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

if has("nvim")
  autocmd TermOpen * setlocal nonumber norelativenumber
  tnoremap <c-W> <c-\><c-n>
endif

" Quickfix list (e.g. from :make)
nnoremap cn :cn<return>
inoremap cn <esc>:cn<return>i

noremap -s ddp
noremap _s dd2kp
inoremap <c-d> ddi
noremap <c-u> bvwU<esc>
inoremap jk <esc>
noremap -rr <esc>:w<return>:!cargo run
noremap -rt <esc>:w<return>:!cargo test<return>
noremap <F9> :tabnext<return>
noremap <F8> :-1tabnext<return>

" The 's' key on this computer is easy to accidentally press.
nnoremap s <esc>

inoremap <F9> <esc>:tabnext<return>i
inoremap <F8> <esc>:-1tabnext<return>i

" Ctrl+Backspace (see help Ctrl+V).
inoremap <C-H> <esc>bdwa
inoremap <C-S> <esc>:w<return>i

" Paste
inoremap <c-V> <esc>"+pa
" nnoremap <c-s-V> <esc>"+pa
inoremap <c-s-V> <esc>"+pa

" Tab switching and scrolling in terminals.
tmap <F9> <c-W>:tabnext<return>
tmap <F8> <c-W>:-1tabnext<return>
tnoremap <ScrollWheelUp> <Up>
tnoremap <ScrollWheelDown> <Down>

" Act more like other editors when using arrow keys when on
" wrapped lines.
set whichwrap+=<,>,h,l,[,]
inoremap <Up> <Esc>gka
inoremap <Down> <Esc>gja

autocmd FileType c setlocal colorcolumn=85
autocmd FileType make setlocal noexpandtab

packadd! matchit " Better % feature

autocmd BufNewFile,BufRead *.dart set syntax=javascript

" Highlight trailing spaces like TODO items!
" See
" https://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
function! CustomHighlighting()
    highlight TrailingSpace ctermbg=DarkYellow guibg=orange term=bold ctermfg=black guifg=black
    match TrailingSpace /\s\+$/
endfun

autocmd BufNew,BufRead * :call CustomHighlighting()

" See https://developer.ibm.com/technologies/linux/tutorials/l-vim-script-2/
function! ClearSpace()
    keeppatterns %s/\s\+$//e
endfun

nmap mcs :call ClearSpace()<CR>

" Change cursor when entering insert mode
" Ref: https://stackoverflow.com/questions/6488683/how-do-i-change-the-cursor-between-normal-and-insert-modes-in-vim
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" s -> script local
function! Search(query, ...)
    echom a:0 . " args, " . (a:0 >= 2 ? a:2 : "NO")
    " a:0 -> number of arguments
    let include = a:0 >= 2 ? split(a:2, ",") : ["*.c", "*.cc", "*.cpp", "*.js", "*.h", "*.py"]
    let dir = a:0 >= 1 ? a:1 : "."
    let files = "\\" . join(include, ",\\")
    let query = join(split(a:query, "'", 1), "\"'\"")

    let cmd = "grep --include={" . files . "} -rin '" . dir . "' -e '" . query . "'"
    let msgCmd = join(split(cmd, "'", 1), "\"'\"")

    let msg = "Searched for '" . query . "' in files matching '" . join(include, ",") . "' in directory '" . dir . "'. This was done using:"
    let filteredMsg = join(split(msg, "'", 1), "\"'\"")

    execute "!" . cmd . "; echo '" . filteredMsg . "'; echo '    " . msgCmd . "';"
endfun

command! -nargs=+ Search :call Search(<f-args>)

source $VIMRUNTIME/ftplugin/man.vim

" Extra customization by other users that use this same vimrc file
if filereadable(expand("~/.vim_extra"))
    source ~/.vim_extra
endif


set conceallevel=1
let g:tex_conceal='abdmgs'
"let g:tex_flavor='latex'
autocmd FileType tex highlight clear Conceal
autocmd FileType man setlocal nonu

" Needed by Joplin when running as an external editor
nnoremap ,w :w<CR>:!touch %<CR>
