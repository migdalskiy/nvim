docker build  -t codex:latest .
docker run -d --name codex -p 5002:5002 -p 5000:5000 -p 3000:3000 -p 1455:2455 -v c:\dev\codex_workspace:/workspace codex:latest
