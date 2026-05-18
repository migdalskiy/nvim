# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

# WSL/Ubuntu

for proxy:port, you can append `-o Acquire::http::Proxy="http://proxy:port"` 
or set up /etc/apt/apt.conf and /etc/environment

```
sudo apt update
sudo apt upgrade
sudo apt install build-essential lua5.1 luarocks ripgrep nodejs npm pipx
pipx ensurepath
pipx install ruff
sudo npm install -g pyright  

# need fresh fzf for LazyVim
sudo curl -L https://github.com/junegunn/fzf/releases/download/v0.72.0/fzf-0.72.0-linux_amd64.tar.gz | sudo tar -xzf - -C /usr/bin

# install dkjson, otherwise lazyvim will complain
sudo luarocks --lua-version=5.1 install dkjson

git clone https://github.com/migdalskiy/nvim.git ~/.config/nvim

```

# Fedora

```sudo dnf upgrade --refresh
sudo dnf install @development-tools
pipx ensurepath
pipx install ruff
sudo dnf install compat-lua luarocks ripgrep fzf nodejs npm pipx
sudo npm install -g pyright

git clone https://github.com/migdalskiy/nvim.git ~/.config/nvim
wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
```
