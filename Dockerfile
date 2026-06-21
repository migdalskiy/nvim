# AI Coding Assistant docker image
# Start from the latest official Node image (Debian-based, full build tools included)
FROM debian:13-slim
ENV DEBIAN_FRONTEND=noninteractive


# 1. Enable apt caching by overriding Debian's default docker-clean behavior
RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# 2. Mount APT caches to speed up OS package downloads
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        curl gnupg ca-certificates tini \
        python3 python3-pip python3-venv \
        fd-find cron rsync screen ripgrep unzip git wget dumb-init \
        build-essential \
        pkg-config \
        cmake \
        ninja-build \
        lua5.1 liblua5.1-0-dev luarocks \
        xclip wl-clipboard \
        iproute2 iptables socat \
    && curl -fsSL https://deb.nodesource.com/setup_26.x | bash - \
    && apt-get install -y nodejs \
    && apt-mark hold nodejs \
    && luarocks install lpeg \
    && luarocks install dkjson \
    && curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-linux-x86_64.tar.gz && tar -C /usr -xzf /tmp/nvim.tar.gz --strip-components=1 \
    && curl -Lo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_amd64.tar.gz && tar -C /usr/bin -xzf /tmp/fzf.tar.gz \
    && rm /tmp/*.tar.gz

# Define arguments for the user, UID, and GID
# We will pass these in dynamically during the build
ARG USERNAME=dev
ARG USER_UID=1099
ARG USER_GID=1099
ARG USER_HOME=/home/${USERNAME}

# Create the group and user to match the host
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

USER $USERNAME

# Default working directory
WORKDIR /workspace

# Make the venv the default Python environment
ENV PATH="${USER_HOME}/.cargo/bin:${USER_HOME}/.config/nvim:${USER_HOME}/.npm-global/bin:${USER_HOME}/.local/bin:${USER_HOME}/venv/bin:$PATH"

# 3. Create the Python venv
# 4. Mount PIP cache to speed up Python dependencies
# 5. Mount NPM cache to speed up global node packages
# 6. Install Lua packages
RUN --mount=type=cache,target=${USER_HOME}/.cache/pip,uid=${USER_UID},gid=${USER_GID},sharing=locked \
    python3 -m venv ${USER_HOME}/venv \
 && ${USER_HOME}/venv/bin/pip install --upgrade \
      flask flask-cors flask-compress \
      debugpy pytest pyright \
      matplotlib plotly \
      torch torchvision torchaudio \
      docling marker-pdf markitdown 

ENV NPM_CONFIG_PREFIX=${USER_HOME}/.npm-global

RUN --mount=type=cache,target=${USER_HOME}/.npm,uid=${USER_UID},gid=${USER_GID},sharing=locked \
    git config --global user.email "migdalskiy@hotmail.com" \
 && git config --global user.name "Sergiy Migdalskiy" \
 && git clone https://github.com/migdalskiy/nvim ${USER_HOME}/.config/nvim \
 && npm install pyright typescript-language-server \
 && npm install --ignore-scripts @earendil-works/pi-coding-agent \
 && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
 && npm install @openai/codex @google/gemini-cli \
 && curl -fsSL https://claude.ai/install.sh | bash \
 && npm install --ignore-scripts @earendil-works/pi-coding-agent 
# && pi install npm:pi-provider-litellm

#or: && curl -fsSL https://pi.dev/install.sh | bash


#RUN  /usr/bin/nvim --headless "+Lazy! sync" +qa && nvim --headless "+qa" && \
#     /usr/bin/nvim -c "autocmd User VeryLazy ++once Lazy sync" +qa

# Show versions (useful sanity check)
#RUN node -v && npm -v && python --version 

# Default command: just a shell
#ENTRYPOINT dumb-init /bin/sh ${USER_HOME}/.config/nvim/startup.sh
#
ENTRYPOINT ["tini", "--"]
CMD ["sleep", "infinity"]
