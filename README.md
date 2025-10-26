# rbiotechsalarydb

For setting up database for rbiotechsalary

```bash
docker compose build 
docker compose up 

# write to db, but first start the db either locally or with docker
uv run csv_to_db.py # writes csv to db
```

see [tests.md](tests.md) for testing the etl script