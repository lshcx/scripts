# scripts

## 项目说明
常用脚本集合

## 使用说明

1. 克隆项目
    ```bash
    git clone https://github.com/lshcx/scripts.git
    ```
2. 运行`cd scripts`进入项目目录

3. 运行`chmod +x *.sh`为脚本添加执行权限

4. 添加到环境变量

    我将所有常用的脚本放在`/home/username/scripts`目录下，每次调用时需要先进入该目录然后调用脚本或输入完整的脚本路径。
    为了方便，可以将该目录添加到环境变量中。运行`vim ~/.bashrc`, 在文件末尾添加如下内容：
    ```bash
    export PATH="$PATH:/home/username/scripts"
    ```
    保存文件后，运行`source ~/.bashrc`使环境变量生效。此时可直接通过脚本文件名调用脚本。

## 脚本说明

### list.sh
列出当前目录下的所有脚本，并显示脚本的大小、修改时间、权限等信息。当忘记脚本名时，可以通过该脚本查看所有脚本。

### auto_scp.sh
上传指定文件夹到指定服务器，是对scp和rsync的封装，支持断点续传。
- 可修改脚本中的USER、IP为常用值，避免每次重复输入；
- ssh使用密钥验证，默认位置"$HOME/.ssh/id_rsa"，可使用--key选项指定其他路径；如果如果你还没有SSH密钥对，可运行`ssh-keygen -t rsa -b 4096`生成一个，然后使用`ssh-copy-id user@ip`将公钥复制到远程服务器，系统会提示你输入远程服务器的密码。
- 使用--resume选项启用断点续传，使用--rm选项在传输完成后删除源文件。 需要本地和远程都安装rsync。


