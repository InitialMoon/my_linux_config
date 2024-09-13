# my_Linux_config

A set of my Linux config, for copy my work config quickly cross different Linux env, now which is Ubuntu.

When you encounter problems with downloading, pay attention to the vpn problem. You can try below ways to solve this issue:

1. If you used shadowsocksR before, you can try switching to a node using Vmess and you will be successful.
2. Set up vpn network proxy for your terminal.
3. Set up vpn network proxy for your git.


2 and 3 we have config in bashrc and config.fish, which is in the proxy_on function, so you can first cp this two config scripts to your home, let them take effect, notice! they won't effect only after you run proxy_on command in shell.

## Version illustration

v1.0 is basic config, with the increasement of v1.0./x means there are more features add to config, but means higher perfromance consumption, you can tailored to individual needs to select a suitable version to config your system.


v1.x have the same principle, but this version have higher requirements for your system version, for example, now to use lazyvim in v1.1 to config the neovim, your neovim need to highter than 0.8.0, but Ubuntu22.04 auto install the 0.6.0, which is not satisfy its need, so v1.1 need a lot update to solve this limitation.

**v1.0** (basic config): bash/fish/tmux/oh-my-posh/oh-my-fish/vimrc
**v1.0.1** (more feature basic config) : base on v1.0, add ranger to manage file system
**v1.1.** : bash/fish/tmux/oh-my-posh/oh-my-fish/vimrc
**v1.2** : add ranger
## Hypothesis

You are on a Linux system, doc only test on Ubuntu18.04/22.04/24.04.

- **git**, version 1.9.5 or later

- apt install can use

- You have a user account on your Linux system

- fzf only can be apt installed on 24.04, so we remove it from auto script

  ```bash
  # Create an account for yourself
  $ sudo useradd -d "/home/moon" -m -s "/bin/bash" moon
  # If you forget your password
  sudo passwd moon
  # login as moon
  su moon
  ```

## Method

### Step 1 Generate and Add ssh key github and your system
[reference](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)

**Generate a ssh key pair on your system**

```
ssh-keygen -t ed25519 -C "jieyingqi814@qq.com"
```

**Add it to your github setting**

Now, you have a ssh key in /home/<user_name>/.ssh/, whose names are ed25519 and ed25519.pub,
copy public key to [github setting](https://github.com/settings/keys).

You can get it use this command
```bash
cat ~/.ssh/id_ed25519.pub
```

**Add it to your system ssh agent**

```bash
ssh-add [path-to-your-key]
ssh-add ~/.ssh/id_ed25519.pub
```

> Note: if you encounter this error `Could not open a connection to your authentication agent.`, 
> which is because you haven't start the SSH agent
>
> Start your ssh agent
>
> If the SSH agent isn't running, you'll need to start it manually.
> 
> For bash shell:
> ```
> $ eval $(ssh-agent)
> ```
> For fish shell:
> ```
> $ eval (ssh-agent)
> ```
> This will start the agent and make it available to handle SSH key operations.

### Step 2 Clone and Run run_config.sh

**Clone git repo and run**

```bash
git clone git@github.com:InitialMoon/my_linux_config.git
cd my_linux_config
chmod +x run_config.sh
./run_config.sh
```

> During the installation process, you may be prompted to enter your user password. Additionally, if Oh My Fish (OMF) is reinstalled, you might be asked to confirm the reinstallation by entering "y".
>
> when this occur :**moon is not in the sudoers file.  This incident will be reported**
>
> If you encounter "`moon is not in the sudoers file. This incident will be reported`" error, means user `moon` not authorized `sudo` command permissions. To solve this problem, add `moon` user to `sudoers` file，but now you can't use `sudo`，you need another user who has sudo permissions to do this thing.
> 
> ### Solution:
> 
> 1. **Switch to a user with administrator privileges**:
>    If you have another administrator user (e.g., `root`), you can log in as that user:
>    ```bash
>    su - root
>    ```
> 
> 2. **Edit the `sudoers` file**:
>    Use the `visudo` command to safely edit the `sudoers` file. `visudo` is the recommended tool for editing this file because it checks for syntax errors.
> 
>    ```bash
>    visudo
>    ```
> 
>    Find the following section (or add it at the end of the file):
>    
>    ```bash
>    # User privilege specification
>    root    ALL=(ALL:ALL) ALL
>    ```
> 
>    Add the following line below it to add the `moon` user to the `sudoers` file:
>    
>    ```bash
>    moon    ALL=(ALL:ALL) ALL
>    ```
> 
> 3. **Save and exit**:
>    In `visudo`, press `Ctrl+X` or `Esc` to exit edit mode, and then save the file.

> 4. **Exit root**:
>    Log out of the `root` user and return to the `moon` user:
>    ```bash
>    exit
>    ```
> 
> 5. **Test sudo permissions**:
>    You can now test whether you have gained `sudo` privileges:
>    ```bash
>    sudo whoami
>    ```
> 
>    If it returns `root`, you have successfully configured sudo access.
>   
> ### If you cannot access the root user:
> If you are unable to switch to `root`, you may need to use recovery mode or single-user mode (during system startup) to gain root access and perform the above steps.
> 
> Be careful when editing the `sudoers` file, as syntax errors can result in losing `sudo` access. Using `visudo` helps prevent such errors.


### Step 3 Install tmux plugin

I have install the omf and setting some config in .tmux.conf for you,  but you have to activate tmux and use `perfix + I` to install plugin, perfix is `Ctrl+d`

### Step 4 Setting Fish to default shell

```bash
chsh -s /usr/bin/fish
```

### Step 5 Install omf themes（if omf not effect）

```fish
omf install bobthefish
omf theme bobthefish
omf doctor
echo 'set theme_color_scheme nord' >> ~/.config/fish/config.fish # if not effect, use below command
set theme_color_scheme nord # only effect once

omf install https://github.com/h-matsuo/fish-color-scheme-switcher
echo 'scheme set catppuccin' >> ~/.config/fish/config.fish# if not effect, use below command
scheme set catppuccin # only once

omf reload
```

### Other things TODO

if pip3 is installed, you can install tldr, you maybe config your python env before this step

## Reference

[1] 主题配色参考[对fish配置的一次尝试[oh-my-fish\] | AlanCorn's Blog](https://alancorn.github.io/blogs/2022/LinuxFishConfig.html#更改默认shell)
