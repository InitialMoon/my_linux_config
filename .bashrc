# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
set HISTCONTROL ignoredups:ignorespace


# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
set HISTSIZE 1000
set HISTFILESIZE 2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt yes
    else
	color_prompt 
    fi
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    set PS1 "\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias fd='find . -name'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#We succeed, oh yeah if you want to have another style, you can change here, but don't do anything above, because I don't know about it.
PS1="\[\e[37;40m\][\[\e[37;40m\]\u@ \[\e[36;40m\]\W\[\e[0m\]]# "
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi


#Include C and CPP's std lib
# C
export C_INCLUDE_PATH=XXXX:$C_INCLUDE_PATH
# CPP
export CPLUS_INCLUDE_PATH=XXX:$CPLUS_INCLUDE_PATH
# usr software path
export PATH=$PATH:~/.local/bin
# vi style Key bindings

set -o vi
# set -o emacs

# vpn
function proxy_on() {
    export http_proxy=http://127.0.0.1:$1
    export https_proxy=$http_proxy
    # 不需要认证的 HTTP 代理
    git config --global http.proxy http://127.0.0.1:$1
    # 不需要认证的 HTTPS 代理
    git config --global https.proxy https://127.0.0.1:$1
    echo -e "终端代理已开启。注意端口号需要和本机进行手动适配，请找到.bashrc文件中的proxy_on函数进行修改"
    echo -e "peoxy_off to close"
}

function proxy_off(){
    unset http_proxy https_proxy
    # 删除 HTTP 代理
    git config --global --unset http.proxy
    # 删除 HTTPS 代理
    git config --global --unset https.proxy
    echo -e "终端代理已关闭。"
    echo -e "peoxy_on to close"
}

echo "git proxy now is"
git config --global --get http.proxy
git config --global --get https.proxy
echo "开启网络代理请使用proxy_on命令"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/moon/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/moon/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/moon/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/moon/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
eval "$(oh-my-posh init bash --config ~/.omp_themes/spaceship.omp.json)"
alias vi nvim

# swap the esc and caps Lock key
setxkbmap -option caps:swapescape
