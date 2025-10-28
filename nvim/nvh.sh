#!/bin/sh
exec nvim --headless --listen "0.0.0.0:5002" "$@"
