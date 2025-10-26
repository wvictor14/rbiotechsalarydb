# Check cron job running

### Check log

```bash
# Check last 50 lines
docker exec <container-name> tail -n 50 /var/log/cron.log
```

### Check If Cron Service Is Running

```bash
# Enter container
docker exec -it <container-name> bash

# Check cron status
service cron status
# or
ps aux | grep cron

# Should see something like:
# root  123  cron
```

### Verify Cron Job Is Registered

```bash
# Inside container
crontab -l
```

### Run every minute for testing

```bash
# Run every minute for testing
* * * * * cd /app && uv run --frozen sync_csv_to_db.py >> /var/log/cron.log 2>&1
```

Rebuild and watch the logs