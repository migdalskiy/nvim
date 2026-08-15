#sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
#podman build  -t aica:latest .

podman run \
  -p 0.0.0.0:3000:3000 -p 0.0.0.0:3001:3001 -p 0.0.0.0:8301:8301 -p 0.0.0.0:8300:8300 -p 0.0.0.0:5002:5002 \
  --memory="56g" --memory-swap="56g" \
  --name aica \
  -v ~/.debug:/home/dev/.debug:z \
  -v ~/aica-app:/app:z \
  -v /var/mnt/i/Data:/data:z \
  -v nvim_data:/home/dev/.local/share/nvim:z \
  -v nvim_state:/home/dev/.local/state/nvim:z \
  -v nvim_cache:/home/dev/.cache/nvim:z \
  -v codex_local:/home/dev/.codex:z \
  -v claude_local:/home/dev/.claude:z \
  --userns=keep-id:uid=1099,gid=1099 \
  --group-add keep-groups \
  --device nvidia.com/gpu=all \
  --security-opt label=type:nvidia_container_t \
  --init -d -it aica sleep infinity



# --cap-add=PERFMON --cap-add=SYS_PTRACE --security-opt seccomp=unconfined
