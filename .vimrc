set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4
" 换行用
" 按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致。
set autoindent
set smartindent
" 行号显示 "
set nu
set relativenumber
"语法高亮"
syntax on
set showcmd
"检查文件类型，并载入对应的缩进规则
filetype indent on
set shiftwidth=4
"光标所在行高亮
set cursorline
"垂直滚动时，光标距离顶部/底部的位置（单位：行）。
set scrolloff=5
"显示光标当前位置
set ruler
"搜索时，高亮显示匹配结果。
set hlsearch
"输入搜索模式时，每输入一个字符，就自动跳到第一个匹配的结果。
set incsearch

"将无用的Ex模式的开关给屏蔽掉
nmap Q <Nop>

" 定义添加注释的函数
function! AddComment()
    " 获取当前行内容
    let line = getline('.')
    " 添加注释符号 '//'
    let line_with_comment = '// ' . line
    " 替换当前行内容为添加了注释的内容
    call setline('.', line_with_comment)
endfunction

" 将函数映射到 Ctrl+/ 键
nnoremap <C-/> :call AddComment()

