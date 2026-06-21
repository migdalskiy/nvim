#sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
#podman build  -t aica:latest .

podman run \
  -p 3000:3000 -p 5002:5002 \
  --name aica \
  -v .:/workspace:Z \
  -v nvim_data:/root/.local/share/nvim \
  -v nvim_state:/root/.local/state/nvim \
  -v nvim_cache:/root/.cache/nvim \
  -v claude_local:/home/dev/.claude:Z \
  --userns=keep-id:uid=1099,gid=1099 \
  --device nvidia.com/gpu=all \
  --security-opt label=type:nvidia_container_t \
  -d -it aica bash
