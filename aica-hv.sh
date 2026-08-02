#sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
#podman build  -t aica:latest .

podman run \
  -p 0.0.0.0:3000:3000 -p 0.0.0.0:3001:3001 -p 0.0.0.0:8301:8301 -p 0.0.0.0:8300:8300 -p 0.0.0.0:5002:5002 \
  -p '[::1]:3000:3000' -p '[::1]:3001:3001' -p '[::1]:8300:8300' -p '[::1]:8301:8301' -p '[::1]:5002:5002' \
  --memory="56g" --memory-swap="56g" \
  --name aica \
  -v ~/L:/workspace:z \
  -v ~/.debug:/home/dev/.debug:z \
  -v ~/.config/opencode:/home/dev/.config/opencode:z \
  --userns=keep-id:uid=1099,gid=1099 \
  --group-add keep-groups \
  --device nvidia.com/gpu=all \
  --security-opt label=type:nvidia_container_t \
  --init -d -it aica sleep infinity



# --cap-add=PERFMON --cap-add=SYS_PTRACE --security-opt seccomp=unconfined
