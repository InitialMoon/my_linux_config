
if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_user_key_bindings
end

function fish_user_key_bindings
    for mode in insert default visual
	bind -M $mode \cf forward-char
    end
end


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
