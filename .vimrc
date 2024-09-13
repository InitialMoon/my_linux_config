"""
"# help doc
"分屏移动 前缀 Ctrl+w hjkl
"在 Vim 中，键位映射命令有以下几类：

"1. **`map`**：普通映射，适用于所有模式（普通模式、插入模式、视觉模式等）。
"2. **`nmap`**：仅限普通模式的映射。
"3. **`vmap`**：仅限视觉模式的映射。 
"4. **`imap`**：仅限插入模式的映射。
"5. **`cmap`**：仅限命令行模式的映射。

"还有其他几种形式：

"- **`nnoremap`**：防止递归的普通模式映射。
"- **`vnoremap`**：防止递归的视觉模式映射。
"- **`inoremap`**：防止递归的插入模式映射。

"这些命令帮助用户自定义 Vim 中的键位行为。
"
"在 Vim 中，组合键的写法主要由键位名称和修饰符（如 Ctrl、Shift、Alt 等）组成。以下是常见组合键的写法：

"1. **Ctrl 键**：
"   - 使用 `<C-键>` 表示。例如：`<C-w>` 表示 `Ctrl + w`。

"2. **Shift 键**：
"   - 使用 `<S-键>` 表示。例如：`<S-h>` 表示 `Shift + h`。

"3. **Alt 键**：
"   - 使用 `<A-键>` 表示。例如：`<A-x>` 表示 `Alt + x`。
"
"4. **Esc 键**：
"   - 使用 `<Esc>` 表示。
"
"5. **F 键（功能键）**：
"   - 使用 `<F1>`、`<F2>` 等表示。例如：`<F5>` 表示 `F5` 键。
"
"### 一些常见示例：
"- `<C-j>`：Ctrl + j
"- `<A-x>`：Alt + x
"- `<C-S-l>`：Ctrl + Shift + l

"你可以通过这些组合键定义自定义映射。
"""
let mapleader=" "
"语法高亮"
syntax on
"检查文件类型，并载入对应的缩进规则
filetype indent on

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
"显示输入的指令"
set showcmd
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
"打开新的文件时不会有高亮搜索的结果
exec "nohlsearch"
" 搜索忽略大小写
set ignorecase
" 只对字符进行匹配，大小写区别存在时就会适配，不存在也不强制检查
set smartcase
" 当前行超出屏幕自动换行
set wrap
" 添加指令模式的自动补全提示
set wildmenu

"将无用的Ex模式的开关给屏蔽掉
nmap Q <Nop>
map s <nop>
map S :w<CR>
map Q :q<CR>
map R :source $MYVIMRC<CR>

" 空格实现关闭搜索结果
nnoremap <LEADER><CR> :nohlsearch<CR>
" 分屏以及退出
map sj :set splitbelow<CR>: split<CR>
map sk :set nosplitright<CR>: split<CR>
map sl :set splitright<CR>: vsplit<CR>
map sh :set nosplitright<CR>: vsplit<CR>

map <LEADER>l <C-w>l
map <LEADER>j <C-w>j
map <LEADER>k <C-w>k
map <LEADER>h <C-w>h

map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>

" 空格实现关闭搜索结果
nnoremap <LEADER><CR> :nohlsearch<CR>
" 分屏以及退出
nnoremap <LEADER>j :split<CR>
nnoremap <LEADER>l :vsplit<CR>
nnoremap <LEADER>q :q<CR>

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

