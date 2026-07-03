#sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
#podman build  -t aica:latest .

podman run \
  -p 0.0.0.0:3000:3000 -p 3001:3001 -p 5002:5002 \
  --memory="60g" --memory-swap="60g" \
  --name aica \
  -v ~/L:/workspace:z \
  -v ~/.debug:/home/dev/.debug:z \
  -v ~/share:/data:z \
  -v nvim_data:/root/.local/share/nvim:z \
  -v nvim_state:/root/.local/state/nvim:z \
  -v nvim_cache:/root/.cache/nvim:z \
  -v claude_local:/home/dev/.claude:z \
  --userns=keep-id:uid=1099,gid=1099 \
  --device nvidia.com/gpu=all \
  --security-opt label=type:nvidia_container_t \
  --init -d -it aica sleep infinity
