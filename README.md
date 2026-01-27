# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

# WSL

for proxy:port, you can append `-o Acquire::http::Proxy="http://proxy:port"`

```
sudo apt update
sudo apt upgrade
sudo apt install build-essential lua5.1 luarocks ripgrep fzf nodejs npm pipx
pipx ensurepath
pipx install ruff
sudo npm install -g pyright --proxy http://proxy:port --https-proxy http://proxy:port

git clone https://github.com/migdalskiy/nvim.git ~/.config/nvim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz
tar xzf nvim-macos-x86_64.tar.gz

nvim ~/.bashrc
export PATH="$PATH:/opt/nvim-linux-x86_64/bin:/home/sergiy/.local/bin"
```

#Fedora Workstation

```sudo dnf upgrade --refresh
sudo dnf install @development-tools
pipx ensurepath
pipx install ruff
sudo dnf install compat-lua luarocks ripgrep fzf nodejs npm pipx
sudo npm install -g pyright

git clone https://github.com/migdalskiy/nvim.git ~/.config/nvim
wget https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
```
