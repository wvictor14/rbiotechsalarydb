#!/bin/bash

# Start cron in background
cron

# Run initial ETL
python csv_to_db.py

# Keep container running and follow logs
tail -f /var/log/cron.log