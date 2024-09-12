#!/bin/bash

# 使脚本在遇到任何错误时立即退出
# set -e

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
    sudo apt-get install fonts-powerline
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
    mkdir ~/.local/bin

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

}

basic_config() {
    # 防止原始设置被覆盖
    echo "备份原始配置"
    FILES=(".profile" ".bashrc" ".vimrc" ".gitconfig" ".tmux.conf")
    BACKUP_DIR=~/backup_configs

    # 创建备份目录（如果不存在）
    mkdir -p "$BACKUP_DIR"

    # 获取当前时间戳
    timestamp=$(date +%Y%m%d_%H%M%S)

    # 遍历每个文件并进行备份
    for file in "${FILES[@]}"; do
        target="$HOME/$file"
        if [ -f "$target" ]; then
            echo "Backing up $target to $BACKUP_DIR/$file.$timestamp"
            cp "$target" "$BACKUP_DIR/$file.$timestamp"
        fi
        # 使用 -u 选项执行覆盖复制
        cp -u "$file" "$HOME/"
    done

    echo "Backup and update completed!"

    cp -u .profile ~/
    cp -u .bashrc ~/
    cp -u .vimrc ~/
    cp -u .gitconfig ~/
}

config_oh_my_posh() {
    cp -r -u .omp_themes ..
    echo "为fish和bash使用oh-my-posh进行主题配置"
    echo "Oh My Posh 设置主题， 如果想要更改请找到\n .bashrc 和 .config/fish/config.fish 文件中的eval '$(oh-my-posh init bash --config ~/.ompthemes/spaceship.json)'"
    if ! grep -q 'eval "$(oh-my-posh init bash --config ~/.omp_themes/spaceship.omp.json)"' ~/.bashrc; then
        echo '\n' >> ~/.bashrc
        echo 'eval "$(oh-my-posh init bash --config ~/.omp_themes/spaceship.omp.json)"' >> ~/.bashrc
        echo "Oh My Posh 已添加到 bash 配置文件中"
    else
        echo "Oh My Posh 已存在于 bash 配置文件中"
    fi

    # if ! grep -q 'oh-my-posh init fish --config ~/.omp_themes/spaceship.omp.json' ~/.config/fish/config.fish; then
    #     echo 'oh-my-posh init fish --config ~/.omp_themes/spaceship.omp.json' >> ~/.config/fish/config.fish
    #     echo "Oh My Posh 已添加到 fish 配置文件中"
    # else
    #     echo "Oh My Posh 已存在于 fish 配置文件中"
    # fi
}

# 配置 oh-my-fish
config_omf() {
    echo "omf安装并设置bobthefish主题"
    omf install bobthefish
    omf theme bobthefish
    omf doctor
    # 设置bobthefish提供的命令提示符的颜色配置
    # 这里的color-scheme指的是在输入命令的时候的高亮颜色方案
    if ! grep -q 'set theme_color_scheme nord' ~/.config/fish/config.fish; then
        echo 'set theme_color_scheme nord' >> ~/.config/fish/config.fish
    fi
    echo "安装并设置catppuccin配色"
    omf install https://github.com/h-matsuo/fish-color-scheme-switcher
    if ! grep -q 'scheme set catppuccin' ~/.config/fish/config.fish; then
        echo 'scheme set catppuccin' >> ~/.config/fish/config.fish
    fi
    omf reload
}

# 配置 fish
config_fish() {
    cp -u -r fish ~/.config/
    if ! grep -q 'COPY . /src/oh-my-fish' ~/.local/share/omf/Dockerfile; then
        echo "Oh My Fish 未安装"
        echo "开始安装..."
        install_omf
    else
        echo "Oh My Fish 已安装"
    fi
    config_omf
}

# 配置 tmux
config_tmux() {
    sudo apt-get -y install xdg-utils
    cp -u .tmux.conf ~/
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux source ~/.tmux.conf
}

# 定义软件名称与对应的安装函数
# 这里的安装顺序是按照首字符进行的，所以没法直接控制安装顺序，
# 暂且先将要在之前安装的部分放在外面
declare -A install_software_list=(
    ["htop"]="install_htop"
    # ["fzf"]="install_fzf"
    ["oh-my-posh"]="install_oh_my_posh"
)

# 定义软件名称与对应的安装函数
declare -A config_software_list=(
    ["oh-my-posh"]="config_oh_my_posh"
    ["fish"]="config_fish"
    ["tmux"]="config_tmux"
    ["omf"]="config_omf"
)

# 复制基本配置文件到用户根目录下
basic_config

if ! command_exists "fish"; then
    echo "fish 未安装，开始安装..."
    install_fish
else
    echo "fish 已安装"
fi

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

# 提示用户需要更改默认 shell（如果需要）
echo "Fish Shell 安装完成。你可以使用 'chsh -s /usr/bin/fish' 来将 fish 设置为默认 shell。"
echo "chsh -l               //列出可用shell"
echo "chsh -s /usr/bin/fish     //设置shell为/usr/bin/fish "

# 一些可能未来要用到的知识
# 将用户本地的local文件夹添加到环境变量中实现
# echo "这是要添加到文件开头的句子" | cat - 文件名 > temp_file && mv temp_file 文件名
