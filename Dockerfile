# AI Coding Assistant docker image
# Start from the latest official Node image (Debian-based, full build tools included)
FROM ubuntu:24.04 AS base
#FROM debian:13-slim
ENV DEBIAN_FRONTEND=noninteractive

# Doing this makes it so we won't be asked questions about where we are during later package installation.
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone \
 # 1. Enable apt caching by overriding Debian's default docker-clean behavior \
 && rm -f /etc/apt/apt.conf.d/docker-clean \
 && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# 2. Mount APT caches to speed up OS package downloads
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
       apt-get update \
    && apt-get install -y curl ca-certificates gnupg \
    && install -d /usr/share/postgresql-common/pgdg \
    && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    && echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt noble-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl wget gnupg ca-certificates tini htop patch ssh net-tools zstd libevent-dev libncurses-dev bison xxd autoconf automake libtool pkg-config \
        postgresql libpq-dev \
        python3 python3-dev python3-pip python3-venv \
        fd-find cron rsync screen ripgrep unzip git dumb-init gdb systemd-coredump lldb strace google-perftools libgoogle-perftools-dev debuginfod \
        postgresql-client-18 \
        build-essential linux-tools-common linux-tools-generic lsb-release software-properties-common llvm-19 \
        pkg-config \
        cmake tig jq \
        ninja-build \
        lua5.1 liblua5.1-0-dev luarocks \
        xclip wl-clipboard \
        iproute2 iptables socat less \
        tesseract-ocr tesseract-ocr-eng libtesseract-dev libleptonica-dev pkg-config \
        libdebuginfod-dev libelf-dev libdw-dev bison flex libtraceevent-dev libaudit-dev \
        bubblewrap iputils-ping dnsutils net-tools traceroute mtr-tiny tcpdump nmap netcat-openbsd iftop iperf3 ethtool \
    && curl -fsSL https://packages.lunarg.com/lunarg-signing-key-pub.asc | gpg --dearmor -o /usr/share/keyrings/lunarg-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/lunarg-archive-keyring.gpg] https://packages.lunarg.com/vulkan noble main" | tee /etc/apt/sources.list.d/lunarg-vulkan-noble.list \
    && curl -fsSL https://deb.nodesource.com/setup_26.x | bash - \
    && ln -s /usr/bin/llvm-mca-19 /usr/bin/llvm-mca \
    && apt-get update && apt-get install -y --no-install-recommends nodejs dxc vulkan-tools libvulkan-dev vulkan-validationlayers vulkan-utility-libraries-dev && apt-mark hold nodejs \
    && luarocks install lpeg \
    && luarocks install dkjson \
    && curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-linux-x86_64.tar.gz && tar -C /usr -xzf /tmp/nvim.tar.gz --strip-components=1 \
    && curl -Lo /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_amd64.tar.gz && tar -C /usr/bin -xzf /tmp/fzf.tar.gz \
    && curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 -o /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel && rm /tmp/*.tar.gz \
    && git clone --branch 3.7b --depth=1 https://github.com/tmux/tmux.git /tmp/tmux && cd /tmp/tmux && ./autogen.sh && ./configure && make -j 16 && make install

#FROM base AS builder
#RUN apt-get update && apt-get install -y --no-install-recommends libelf-dev libdw-dev bison flex libtraceevent-dev libaudit-dev
#RUN mkdir /app
#WORKDIR /app
#RUN git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
#RUN cd linux/tools/perf && make NO_JVMTI=1 NO_LIBPERL=1 NO_LIBPYTHON=1 NO_JEVENTS=1

#FROM base
#COPY --from=builder /app/linux/tools/perf /usr/local/perf



# Define arguments for the user, UID, and GID
# We will pass these in dynamically during the build
ARG USERNAME=dev
ARG USER_UID=1099
ARG USER_GID=1099
ARG USER_HOME=/home/${USERNAME}
ENV VULKAN_CACHE_DIR=/root/.cache/vulkan
ENV VULKAN_SDK=/opt/vulkan/x86_64
ENV PATH="${VULKAN_SDK}/bin:$PATH"
ENV LD_LIBRARY_PATH="${VULKAN_SDK}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

# Create the group and user to match the host
RUN --mount=type=cache,target=/root/.cache/vulkan \
    mv /usr/bin/perf /usr/bin/perf.bak \
 && ln -s /usr/lib/linux-tools/*/perf /usr/bin/perf \
 && groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
 && ln -s ${USER_HOME}/venv /venv && ln -s ${USER_HOME}/venv /opt/venv \
 && mkdir -p ${VULKAN_CACHE_DIR} \
 && if [ ! -f "${VULKAN_CACHE_DIR}/vulkansdk.tar.xz" ]; then \
        curl -L https://sdk.lunarg.com/sdk/download/1.4.350.1/linux/vulkansdk-linux-x86_64-1.4.350.1.tar.xz \
        -o ${VULKAN_CACHE_DIR}/vulkansdk.tar.xz; \
    fi \
 && mkdir -p /opt/vulkan \
 && tar -xf ${VULKAN_CACHE_DIR}/vulkansdk.tar.xz -C /opt/vulkan --strip-components=1 \
 && apt install -y build-essential pkg-config curl bzip2 zlib1g-dev libbz2-dev liblzma-dev libzstd-dev libcurl4-openssl-dev \
 && cd /tmp && curl -fLO https://sourceware.org/ftp/elfutils/0.195/elfutils-0.195.tar.bz2 && tar -xf elfutils-0.195.tar.bz2 \
 && cd elfutils-0.195 && ./configure --prefix=/opt/elfutils-0.195 && make -j"$(nproc)" && make install

USER $USERNAME

# Make the venv the default Python environment
ENV PATH="${USER_HOME}/.cargo/bin:${USER_HOME}/.config/nvim:${USER_HOME}/.npm-global/bin:${USER_HOME}/.local/bin:${USER_HOME}/venv/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/elfutils-0.195/lib:$LD_LIBRARY_PATH"

# 3. Create the Python venv
# 4. Mount PIP cache to speed up Python dependencies
# 5. Mount NPM cache to speed up global node packages
# 6. Install Lua packages
RUN --mount=type=cache,target=${USER_HOME}/.cache/pip,uid=${USER_UID},gid=${USER_GID},sharing=locked \
    python3 -m venv ${USER_HOME}/venv \
 && ${USER_HOME}/venv/bin/pip install --upgrade \
      flask flask-cors flask-compress requests \
      fastapi uvicorn python-multipart duckdb \
      debugpy pytest pyright psycopg2 \
      matplotlib plotly sqlit-tui inject clickhouse-connect pipx pytest-asyncio\
      torch torchvision torchaudio maturin \
      docling marker-pdf markitdown easyocr rapidocr_onnxruntime onnxruntime-gpu tesserocr


ENV NPM_CONFIG_PREFIX=${USER_HOME}/.npm-global

#RUN --mount=type=cache,target=${USER_HOME}/.npm,uid=${USER_UID},gid=${USER_GID},sharing=locked \
RUN    git config --global user.email "migdalskiy@hotmail.com" \
 && git config --global user.name "Sergiy Migdalskiy" \
 && git config --global core.editor "nvim" \
 && git clone https://github.com/migdalskiy/nvim ${USER_HOME}/.config/nvim \
 && curl -LsSf https://astral.sh/uv/install.sh | sh \
 && npm install -g pyright typescript-language-server \
 && npm install -g --ignore-scripts @earendil-works/pi-coding-agent \
 && curl -LsSf https://astral.sh/uv/install.sh | sh \
 && echo source ~/venv/bin/activate >> ~/.bashrc \
 && pi install npm:pi-provider-litellm \
 && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
 && npm install -g @openai/codex @google/gemini-cli \
 && curl -fsSL https://claude.ai/install.sh | bash \
 && cargo install cargo-binstall --locked \
 && cargo binstall --no-confirm --locked --disable-telemetry tree-sitter-cli \
 && curl -fsSL https://bun.com/install | bash \
 && /usr/bin/nvim --headless "+Lazy! sync" +qa && nvim --headless "+qa" \
 && /usr/bin/nvim -c "autocmd User VeryLazy ++once Lazy sync" +qa \
 && printf 'set -g default-terminal "screen-256color"\nset-environment -g LANG "C.utf8"\nset-environment -g LC_ALL "C.utf8"\n' > "${USER_HOME}/.tmux.conf"


ENV LANG=C.utf8
ENV LC_ALL=C.utf8

#or: && curl -fsSL https://pi.dev/install.sh | bash

# Show versions (useful sanity check)
#RUN node -v && npm -v && python --version 

# Default command: just a shell
#ENTRYPOINT dumb-init /bin/sh ${USER_HOME}/.config/nvim/startup.sh
#

WORKDIR /app
ENTRYPOINT ["tini", "--"]
CMD ["sleep", "infinity"]
