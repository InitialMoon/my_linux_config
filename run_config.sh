#!/bin/bash

# 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 安装 oh-my-posh
install_oh_my_posh() {
    echo "正在安装 Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
    echo "Oh My Posh 安装完成"
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
    ["oh-my-posh"]="install_oh_my_posh"
    ["fish"]="install_fish"
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

