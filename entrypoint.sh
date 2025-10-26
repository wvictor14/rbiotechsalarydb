#!/bin/bash
set -e # exit on error

# Run initial ETL
cd /app && uv run --frozen csv_to_db.py

# writes the environment variables to file, for crontab access
# https://stackoverflow.com/questions/27771781/how-can-i-access-docker-set-environment-variables-from-a-cron-job
printenv | grep -v "no_proxy" >> /etc/environment

# Keep container running and follow logs
service cron start

# Follow logs (this keeps container running and shows output)
exec tail -f /var/log/cron.log