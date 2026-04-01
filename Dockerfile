# AI Coding Assistant docker image
# Start from the latest official Node image (Debian-based, full build tools included)
FROM debian:13-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - 
# Install Python and essential tools only, skip Ubuntu-style repository stuff
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nodejs npm \
        python3 python3-pip python3-venv \
        fd-find cron rsync screen ripgrep unzip git curl wget dumb-init \
        build-essential \
        pkg-config \
        cmake \
        ninja-build \
        lua5.1 liblua5.1-0-dev luarocks \
        ca-certificates && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools wheel && \
    /opt/venv/bin/pip install flask flask-cors flask-compress debugpy pytest pyright matplotlib plotly && \
    npm install -g pyright typescript-language-server && \
    luarocks install lpeg && \
    luarocks install dkjson && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Make the venv the default Python environment
ENV PATH="/home/$USERNAME/.cargo/bin:/home/$USERNAME/.config/nvim:/opt/venv/bin:$PATH"

RUN  curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz && tar -C /usr -xzf /tmp/nvim.tar.gz --strip-components=1 && \
     curl -Lo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v0.70.0/fzf-0.70.0-linux_amd64.tar.gz && tar -C /usr/bin -xzf /tmp/fzf.tar.gz && \
     rm /tmp/*.tar.gz

RUN apt-get update && apt-get install -y iproute2 iptables socat


# Define arguments for the user, UID, and GID
# We will pass these in dynamically during the build
ARG USERNAME=dev
ARG USER_UID=1001
ARG USER_GID=1001

# Create the group and user to match the host
RUN groupadd --gid $USER_GID $USERNAME && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

RUN git clone https://github.com/migdalskiy/nvim /home/$USERNAME/.config/nvim
COPY nvim/ /home/$USERNAME/.config/nvim/
RUN chown -R $USERNAME:$USER_GID /home/$USERNAME/.config/nvim && ls /home/$USERNAME/.config/
RUN chmod +x /home/$USERNAME/.config/nvim/*.sh
USER $USERNAME

# Default working directory
WORKDIR /workspace


# install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV NPM_CONFIG_PREFIX=/home/$USERNAME/.npm-global
ENV PATH=/home/$USERNAME/.npm-global/bin:$PATH
RUN npm install -g @openai/codex @google/gemini-cli
RUN curl -fsSL https://claude.ai/install.sh | bash

RUN git config --global user.email "migdalskiy@hotmail.com" && git config --global user.name "Sergiy Migdalskiy"

RUN nvim --headless "+qa"

#RUN  /usr/bin/nvim --headless "+Lazy! sync" +qa && nvim --headless "+qa" && \
#     /usr/bin/nvim -c "autocmd User VeryLazy ++once Lazy sync" +qa

# Show versions (useful sanity check)
#RUN node -v && npm -v && python --version 

# Default command: just a shell
ENTRYPOINT ["dumb-init", "/bin/sh", "/home/$USERNAME/.config/nvim/startup.sh"]
