#!/usr/local/bin/dumb-init /bin/sh

# Start cron service in the background
cron

# Run your desired main process (e.g., nvim loop)
while true; do
    nvim --headless --listen 0.0.0.0:5002
    sleep 1
done