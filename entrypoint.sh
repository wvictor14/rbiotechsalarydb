#!/bin/bash
set -e # exit on error

# writes the environment variables to file, for crontab access
printenv | grep -v "no_proxy" >> /etc/environment

# Start cron in background
service cron start

# Run initial ETL
cd /app && uv run --frozen csv_to_db.py

# Keep container running and follow logs
exec tail -f /var/log/cron.log