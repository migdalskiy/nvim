# AI Coding Assistant docker image
# Start from the latest official Node image (Debian-based, full build tools included)
FROM debian:13-slim
ENV DEBIAN_FRONTEND=noninteractive

# Export the Python venv path so we don't have to type /opt/venv/bin/... every time
ENV PATH="/opt/venv/bin:$PATH"

# 1. Enable apt caching by overriding Debian's default docker-clean behavior
RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# 2. Mount APT caches to speed up OS package downloads
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl gnupg ca-certificates \
        python3 python3-pip python3-venv \
        fd-find cron rsync screen ripgrep unzip git wget dumb-init \
        build-essential \
        pkg-config \
        cmake \
        ninja-build \
        lua5.1 liblua5.1-0-dev luarocks && \
    curl -fsSL https://deb.nodesource.com/setup_26.x | bash - && \
    apt-get install -y nodejs && \
    apt-mark hold nodejs

# 3. Create the Python venv
RUN python3 -m venv /opt/venv

# 4. Mount PIP cache to speed up Python dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --upgrade pip setuptools wheel && \
    pip install flask flask-cors flask-compress debugpy pytest pyright matplotlib plotly

# 5. Mount NPM cache to speed up global node packages
RUN --mount=type=cache,target=/root/.npm \
    npm install -g pyright typescript-language-server && \
    npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# 6. Install Lua packages
RUN luarocks install lpeg && \
    luarocks install dkjson

RUN  curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-linux-x86_64.tar.gz && tar -C /usr -xzf /tmp/nvim.tar.gz --strip-components=1 && \
     curl -Lo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_amd64.tar.gz && tar -C /usr/bin -xzf /tmp/fzf.tar.gz && \
     rm /tmp/*.tar.gz

RUN apt-get update && apt-get install -y iproute2 iptables socat


# Define arguments for the user, UID, and GID
# We will pass these in dynamically during the build
ARG USERNAME=dev
ARG USER_UID=1099
ARG USER_GID=1099

# Create the group and user to match the host
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME && \
    git clone https://github.com/migdalskiy/nvim /home/$USERNAME/.config/nvim

COPY nvim/ /home/$USERNAME/.config/nvim/
RUN chown -R $USERNAME:$USER_GID /home/$USERNAME/.config/nvim && \
    ls /home/$USERNAME/.config/ && \
    chmod +x /home/$USERNAME/.config/nvim/*.sh

USER $USERNAME

# Default working directory
WORKDIR /workspace


# install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV NPM_CONFIG_PREFIX=/home/$USERNAME/.npm-global
# Make the venv the default Python environment
ENV PATH="$HOME/.cargo/bin:$HOME/.config/nvim:/opt/venv/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"
RUN npm install -g @openai/codex @google/gemini-cli
RUN curl -fsSL https://claude.ai/install.sh | bash
#RUN curl -fsSL https://pi.dev/install.sh | bash
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent && pi install npm:pi-provider-litellm

RUN git config --global user.email "migdalskiy@hotmail.com" && git config --global user.name "Sergiy Migdalskiy"

RUN nvim --headless "+qa"

#RUN  /usr/bin/nvim --headless "+Lazy! sync" +qa && nvim --headless "+qa" && \
#     /usr/bin/nvim -c "autocmd User VeryLazy ++once Lazy sync" +qa

# Show versions (useful sanity check)
#RUN node -v && npm -v && python --version 

# Default command: just a shell
ENTRYPOINT dumb-init /bin/sh $HOME/.config/nvim/startup.sh