#!/bin/bash

# 使脚本在遇到任何错误时立即退出
set -e

# 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 全局安装 unzip
install_htop() {
    apt-get install htop
}

# 全局安装 unzip
install_unzip() {
    apt-get install unzip
}

# 配置 oh-my-posh
config_oh_my_posh() {
    echo "正在为 Bash 终端配置 Oh My Posh..."

    # 为当前用户的 Bash 终端配置 oh-my-posh
    if ! grep -q 'oh-my-posh' ~/.bashrc; then
        echo 'eval "$(oh-my-posh init bash)"' >> ~/.bashrc
        echo "Oh My Posh 已添加到 Bash 配置文件中"
    else
        echo "Oh My Posh 已存在于 Bash 配置文件中"
    fi

    # 为 Fish shell 配置 oh-my-posh
    echo "正在为 Fish 终端配置 Oh My Posh..."
    if ! grep -q 'oh-my-posh' ~/.config/fish/config.fish; then
        echo 'oh-my-posh init fish | source' >> ~/.config/fish/config.fish
        echo "Oh My Posh 已添加到 Fish 配置文件中"
    else
        echo "Oh My Posh 已存在于 Fish 配置文件中"
    fi

    # 提示用户手动重载配置
    echo "请手动运行 'source ~/.bashrc' 或 'exec bash' 以使 Bash 配置生效。"
    echo "Fish 用户请手动运行 'exec fish' 以使 Fish 配置生效。"
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

    echo "Oh My Posh 添加到环境变量中"
    'export PATH=$PATH:~/.local/bin' >> ~/.bashrc

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
}

# 定义软件名称与对应的安装函数
declare -A install_software_list=(
    ["fish"]="install_fish"
    ["oh-my-posh"]="install_oh_my_posh"
    ["htop"]="install_htop"
)

# 定义软件名称与对应的安装函数
declare -A config_software_list=(
    ["oh-my-posh"]="config_oh_my_posh"
)

# 复制基本配置文件到用户根目录下
cp -u .profile ~/
cp -u .bashrc ~/
cp -u .vimrc ~/
cp -u .gitconfig ~/
cp -u .tmux.conf ~/
cp -r .tmux ~/
cp -u -r fish ~/.conf/
cp -u -r omf ~/.conf/

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

