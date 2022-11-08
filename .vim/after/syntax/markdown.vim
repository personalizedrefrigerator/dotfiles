" See https://stackoverflow.com/questions/32865744/vim-syntax-and-latex-math-inside-markdown
" and https://stsievert.com/blog/2016/01/06/vim-jekyll-mathjax/

" See :help :syn-include and :help :syn-sync
unlet b:current_syntax
syn include @TeX syntax/tex.vim
syn sync fromstart
let b:current_syntax="markdown"

" Block math
syn region math_block start=/\$\$$/ end=/\$\$$/ contains=@TeX keepend

" Inline math
syn match math_inline '\$[^$\r\n]\{1,\}\$' contains=@TeX
syn region code_block start='```' end='```'
syn match todo '[=][=].\{-}[=][=]'

highlight link code_block Function
highlight link math_inline Statement
highlight link math_block Function
highlight link todo Todo

highlight clear Conceal
