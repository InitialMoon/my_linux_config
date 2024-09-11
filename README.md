# my_Linux_config

A set of my Linux config, for copy my work config quickly cross different Linux env, now which is Ubuntu.

当遇到下载不下来的时候注意梯子的问题，如果之前用的是shadowsocksR可以试试换成使用Vmess的节点就可以成功了

## Hypothesis

You are on a Linux system, doc only test on Ubuntu24.04.

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
> 出现“`moon is not in the sudoers file. This incident will be reported`”的错误，意味着用户 `moon` 没有被授予执行 `sudo` 命令的权限。解决这个问题的方法是将 `moon` 用户添加到 `sudoers` 文件中，但由于你目前无法使用 `sudo`，需要使用另一个具有管理员权限的用户来进行操作。
>
> ### 解决方法：
>
> 1. **切换到具有管理员权限的用户**：
>    如果你有另一个管理员用户（例如 `root`），可以登录该用户：
>    ```bash
>    su - root
>    ```
>
> 2. **编辑 `sudoers` 文件**：
>    使用 `visudo` 命令安全地编辑 `sudoers` 文件。`visudo` 是用于编辑该文件的推荐工具，因为它会检查文件的语法错误。
>    
>    ```bash
>    visudo
>    ```
>
>    找到以下部分（或者在文件末尾添加）：
>    
>    ```bash
>    # User privilege specification
>    root    ALL=(ALL:ALL) ALL
>    ```
>
>    在下面添加一行，将 `moon` 用户添加到 `sudoers` 中：
>    
>    ```bash
>    moon    ALL=(ALL:ALL) ALL
>    ```
>
> 3. **保存并退出**：
>    在 `visudo` 中，按 `Ctrl+X` 或 `Esc` 退出编辑模式，然后保存文件。
>
> 4. **退出 root**：
>    退出 `root` 用户，返回 `moon` 用户：
>    ```bash
>    exit
>    ```
>
> 5. **测试 sudo 权限**：
>    你现在可以测试是否已经获得 `sudo` 权限：
>    ```bash
>    sudo whoami
>    ```
>
>    如果返回 `root`，则表示成功。
>
> ### 如果无法访问 root 用户：
> 如果你无法切换到 `root`，可能需要通过恢复模式或单用户模式（在系统启动时）来获得 root 权限，进而进行上述操作。
>
> 需要小心编辑 `sudoers` 文件，因为格式错误可能导致你无法使用 `sudo`。使用 `visudo` 是防止这种错误的安全措施。

### Step 3 Install tmux plugin

I have install the omf and setting some config in .tmux.conf for you,  but you have to activate tmux and use `perfix + I` to install plugin, perfix is `Ctrl+d`

### Other things TODO

if pip3 is installed, you can install tldr, you maybe config your python env before this step

## Reference

[1] 主题配色参考[对fish配置的一次尝试[oh-my-fish\] | AlanCorn's Blog](https://alancorn.github.io/blogs/2022/LinuxFishConfig.html#更改默认shell)
