docker build  -t aica:latest .
docker run -d -p 5002:5002 -p 5000:5000 -p 3000:3000 --name aica -v c:\dev\codex_workspace:/workspace aica:latest
