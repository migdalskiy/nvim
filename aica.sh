#podman build  -t aica:latest .

podman run -p 3000:3000 -p 5002:5002 --name aica -v .:/workspace:Z -v nvim_data:/root/.local/share/nvim -v nvim_state:/root/.local/state/nvim  -v nvim_cache:/root/.cache/nvim -v claude_local:/home/dev/.claude:Z   --userns=keep-id:uid=1099,gid=1099 -d -it aica bash
#docker run -d --name aica -p 5002:5002 -p 5000:5000 -p 3000:3000 -p 1455:2455 -v ~/aica_workspace:/workspace aica:latest
