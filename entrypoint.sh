#!/bin/bash
set -e # exit on error

# Start cron in background
service cron start

# Run initial ETL
cd /app && uv run --frozen csv_to_db.py

# Keep container running and follow logs
exec tail -f /var/log/cron.log