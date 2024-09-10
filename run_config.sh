#!/bin/bash

# 使脚本在遇到任何错误时立即退出
set -e

# 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 全局安装 unzip
install_unzip() {
    apt-get install unzip
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

    if ! curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin; then
        echo "Oh My Posh 安装失败"
        exit 1
    fi
    echo "Oh My Posh 安装完成"

    echo "Oh My Posh 安装meslo字体"
    oh-my-posh font install meslo

    echo "使Oh My Posh 在终端生效"
    echo "当前所在的终端是"
    oh-my-posh get shell

    # Add the following to ~/.bashrc (could be ~/.profile or ~/.bash_profile depending on your environment):
    eval "$(oh-my-posh init bash)"

    # Once added, reload your profile for the changes to take effect.
    exec bash

    # Or, when using ~/.profile.
    . ~/.profile

    echo "将终端的默认shell切换为fish进行配置"
    fish

    oh-my-posh init fish | source

    exec fish
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
}

# 定义软件名称与对应的安装函数
declare -A software_list=(
    # fish 必须在oh-my-posh之前进行安装，否则oh-my-posh在进行fish配置的时候会报错
    ["fish"]="install_fish"
    ["oh-my-posh"]="install_oh_my_posh"
)

# 循环检查并安装软件
for software in "${!software_list[@]}"; do
    if ! command_exists "$software"; then
        echo "$software 未安装，开始安装..."
        ${software_list[$software]}
    else
        echo "$software 已安装"
    fi
done

