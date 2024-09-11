#!/bin/bash

# 使脚本在遇到任何错误时立即退出
set -e

# 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 全局安装 htop
install_htop() {
    sudo apt-get install htop
}

# 全局安装 fzf
install_fzf() {
    sudo apt-get install fzf
}

# 全局安装 unzip
install_unzip() {
    sudo apt-get install unzip
}

# 用户自身安装oh my fish，主要是为了支持一些插件
install_omf() {
    # install oh my fish
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
    fish install --path=~/.local/share/omf --config=~/.config/omf
}

# 安装 oh-my-posh
install_oh_my_posh() {
    echo "正在安装 Oh My Posh..."
    echo "检测是否安装了unzip..." 

    if ! command_exists "unzip"; then
        echo "unzip 未安装，开始安装..."
        install_unzip 
        echo "unzip 已安装"
    else
        echo "unzip 已安装"
    fi

    echo "Oh My Posh 添加到环境变量中"
    if ! grep -q 'export PATH=$PATH:~/.local/bin' ~/.bashrc; then
        echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
        echo "Oh My Posh 已添加到 bash 配置文件中"
    else
        echo "Oh My Posh 已存在于 bash 配置文件中"
    fi

    if ! command_exists "oh-my-posh"; then
        echo "oh-my-posh 未安装，开始安装..."
        if ! curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin; then
            echo "Oh My Posh 安装失败"
            exit 1
        fi
        echo "oh-my-posh 已安装"
    else
        echo "oh-my-posh 已安装"
    fi

    echo "Oh My Posh 安装完成"

    echo "Oh My Posh 安装meslo字体"
    oh-my-posh font install meslo
}

# 安装 fish shell
install_fish() {
    echo "正在安装 Fish Shell..."
    if ! command_exists "apt"; then
        echo "无法找到 apt，安装 fish shell 失败"
        return
    fi

    # 先安装 fish 的依赖
    sudo apt update
    sudo apt install -y software-properties-common

    # 添加 fish 的 PPA 并安装
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt update
    sudo apt install -y fish

    # 为当前用户添加 fish 到可用 shell 列表
    if ! grep -q '/usr/bin/fish' /etc/shells; then
        echo '/usr/bin/fish' | sudo tee -a /etc/shells
    fi

    # 提示用户需要更改默认 shell（如果需要）
    echo "Fish Shell 安装完成。你可以使用 'chsh -s /usr/bin/fish' 来将 fish 设置为默认 shell。"
    echo "chsh -l               //列出可用shell"
    echo "chsh -s /bin/fish     //设置shell为/bin/fish"
}

basic_config() {
    cp -u .profile ~/
    cp -u .bashrc ~/
    cp -u .vimrc ~/
    cp -u .gitconfig ~/
}

config_oh_my_posh() {
    cp -r -u ./.omp_themes ..
    echo "为fish和bash使用oh-my-posh进行主题配置"
    echo "Oh My Posh 设置主题， 如果想要更改请找到\n .bashrc 和 .config/fish/config.fish 文件中的eval '$(oh-my-posh init --shell bash --config ~/.ompthemes/spaceship.json)'"
    if ! grep -q 'eval "$(oh-my-posh init bash --config ~/.omp_themes/spaceship.omp.json)"' ~/.bashrc; then
        echo 'eval "$(oh-my-posh init bash --config ~/.omp_themes/spaceship.omp.json)"' >> ~/.bashrc
        echo "Oh My Posh 已添加到 bash 配置文件中"
    else
        echo "Oh My Posh 已存在于 bash 配置文件中"
    fi

    if ! grep -q 'oh-my-posh init fish --config ~/.omp_themes/spaceship.omp.json' ~/.config/fish/config.fish; then
        echo 'oh-my-posh init fish --config ~/.omp_themes/spaceship.omp.json' >> ~/.config/fish/config.fish
        echo "Oh My Posh 已添加到 fish 配置文件中"
    else
        echo "Oh My Posh 已存在于 fish 配置文件中"
    fi

}

# 配置 oh-my-fish
config_omf() {
    echo "正在为 fish 终端配置 Oh My Fish..."

    omf install https://github.com/h-matsuo/fish-color-scheme-switcher
    # 为 Fish shell 配置 oh-my-posh

    # 提示用户手动重载配置
    echo "Fish 用户请手动运行 'exec fish' 以使 Fish 配置生效。"
    omf reload
}

# 配置 fish
config_fish() {
    # if ! command_exists "omf"; then
    #     echo "omf 未安装，开始安装..."
    #     install_omf
    #     config_omf
    # else
    #     echo "omf 已安装"
    # fi
    cp -u -r fish ~/.config/
    # cp -u -r omf ~/.config/
}

# 配置 tmux
config_tmux() {
    cp -u .tmux.conf ~/
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux source ~/.tmux.conf
}

# 定义软件名称与对应的安装函数
declare -A install_software_list=(
    ["htop"]="install_htop"
    ["fzf"]="install_fzf"
    ["fish"]="install_fish"
    ["oh-my-posh"]="install_oh_my_posh"
    # ["omf"]="install_omf"
)

# 定义软件名称与对应的安装函数
declare -A config_software_list=(
    ["oh-my-posh"]="config_oh_my_posh"
    ["fish"]="config_fish"
    ["tmux"]="config_tmux"
)

# 复制基本配置文件到用户根目录下
basic_config

# 循环检查并安装软件
for software in "${!install_software_list[@]}"; do
    if ! command_exists "$software"; then
        echo "$software 未安装，开始安装..."
        ${install_software_list[$software]}
    else
        echo "$software 已安装"
    fi
done

# 循环检查并配置安装的软件
for software in "${!config_software_list[@]}"; do
    if  command_exists "$software"; then
        echo "开始配置 $software"
        ${config_software_list[$software]}
    else
        echo "$software 未安装"
    fi
done

# 一些可能未来要用到的知识
# 将用户本地的local文件夹添加到环境变量中实现
# echo "这是要添加到文件开头的句子" | cat - 文件名 > temp_file && mv temp_file 文件名
