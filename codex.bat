rem docker build  -t aica:latest .
docker run -d --init -p 5002:5002 -p 5000:5000 -p 3000:3000 --name aica ^
  -v M:\L\perf-browse:/workspace/perf-browse ^
  -v m:\L\.debug:/home/dev/.debug ^
  -v nvim_data:/root/.local/share/nvim ^
  -v nvim_state:/root/.local/state/nvim ^
  -v nvim_cache:/root/.cache/nvim ^
  -v claude_local:/home/dev/.claude ^
  aica:latest
