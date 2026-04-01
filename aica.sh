docker build  -t aica:latest .


docker run -d --name aica -p 5002:5002 -p 5000:5000 -p 3000:3000 -p 1455:2455 -v ~/aica_workspace:/workspace aica:latest
