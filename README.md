# my_Linux_config

A set of my Linux config, for copy my work config quickly cross different Linux env, now which is Ubuntu.

## Hypothesis

You are on a Linux system, doc only test on Ubuntu18.04/20.04.

- **git**, version 1.9.5 or later

- apt install can use

- You have a user account on your Linux system

  ```bash
  # Create an account for yourself
  $ sudo useradd -d "/home/moon" -m -s "/bin/bash" moon
  # If you forget your password, 
  sudo passwd moon
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
```
cat id_ed25519.pub
```

**Add it to your system ssh agent**

```
ssh-add [path-to-your-key]
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



### Step 3 

pip3 is installed, to install tldr, you maybe config your python env before this 
