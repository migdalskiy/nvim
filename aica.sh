#sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
#podman build  -t aica:latest .

podman run \
  -p 0.0.0.0:3000:3000 -p 0.0.0.0:3001:3001 -p 0.0.0.0:8301:8301 -p 0.0.0.0:8300:8300 -p 0.0.0.0:5002:5002 \
  --memory="60g" --memory-swap="60g" \
  --name aica \
  -v ~/L:/workspace:z \
  -v ~/.debug:/home/dev/.debug:z \
  -v ~/.config/opencode:/home/dev/.config/opencode:z \
  -v /var/mnt/data/shared:/var/mnt/data/shared:z \
  -v /var/mnt/data/tmp:/var/mnt/data/tmp:z \
  --userns=keep-id:uid=1099,gid=1099 \
  --group-add keep-groups \
  --device nvidia.com/gpu=all \
  --security-opt label=type:nvidia_container_t \
  --init -d -it aica sleep infinity



# --cap-add=PERFMON --cap-add=SYS_PTRACE --security-opt seccomp=unconfined
