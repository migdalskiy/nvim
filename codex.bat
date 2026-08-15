rem docker build  -t aica:latest .
docker run -d --init -p 5002:5002 -p 5000:5000 -p 3000:3000 --name aica --hostname aica-docker ^
  -v ../aica-app:/app ^
  -v M:\Data-Tmp:/data ^
  -v nvim_data:/home/dev/.local/share/nvim ^
  -v nvim_state:/home/dev/.local/state/nvim ^
  -v nvim_cache:/home/dev/.cache/nvim ^
  -v codex_local:/home/dev/.codex ^
  -v claude_local:/home/dev/.claude ^
  aica:latest
