#!/bin/bash

# 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 安装 oh-my-posh
install_oh_my_posh() {
    echo "正在安装 Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
    echo "Oh My Posh 安装完成"
}

# 安装 fish shell
install_fish() {
    echo "正在安装 Fish Shell..."
    sudo apt update && sudo apt install -y fish
    echo "Fish Shell 安装完成"
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

