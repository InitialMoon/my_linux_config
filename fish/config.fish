
if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_user_key_bindings
end

function fish_user_key_bindings
    for mode in insert default visual
	bind -M $mode \cf forward-char
    end
end

function proxy_on
    set -x http_proxy http://127.0.0.1:$argv[1]
    set -x https_proxy $http_proxy
    # 不需要认证的 HTTP 代理
    git config --global http.proxy http://127.0.0.1:$argv[1]

# 不需要认证的 HTTPS 代理
    git config --global https.proxy https://127.0.0.1:$argv[1]

    echo "终端代理已开启。注意端口号需要和本机进行手动适配，请找到 config.fish 文件中的 proxy_on 函数进行修改"
    echo "proxy_off to close"
end

function proxy_off
    set -e http_proxy
    set -e https_proxy
    # 删除 HTTP 代理
    git config --global --unset http.proxy

# 删除 HTTPS 代理
    git config --global --unset https.proxy

    echo "终端代理已关闭。"
end

echo "开启网络代理请使用proxy_on命令"
# sudo service binfmt-support start

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /home/moon/miniconda3/bin/conda
#     eval /home/moon/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# else
#     if test -f "/home/moon/miniconda3/etc/fish/conf.d/conda.fish"
#         . "/home/moon/miniconda3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH "/home/moon/miniconda3/bin" $PATH
#     end
# end
# <<< conda initialize <<<

# set -Ux PYENV_ROOT $HOME/.pyenv
# set -Ux PATH $PYENV_ROOT/bin $PATH
# set -Ux PATH /usr/local/nodejs/bin


# Created by `pipx` on 2024-08-21 12:48:44
# Add user software to env path
set PATH $PATH ~/.local/bin

# nodejs18 setting

# fish_add_path /home/linuxbrew/.linuxbrew/opt/node@18/bin
# set -gx LDFLAGS "-L/home/linuxbrew/.linuxbrew/opt/node@18/lib"
# set -gx CPPFLAGS "-I/home/linuxbrew/.linuxbrew/opt/node@18/include"
set theme_color_scheme nord
scheme set catppuccin
