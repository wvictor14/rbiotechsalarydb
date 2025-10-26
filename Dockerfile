FROM python:3.14-slim

RUN apt update -y && apt install cron -y

WORKDIR /app

# python dependecies
# uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set UV_PROJECT to install packages directly into a specified directory
ENV UV_PROJECT=/app/.venv

COPY pyproject.toml uv.lock .
RUN uv sync --frozen

# Set up job
COPY csv_to_db.py .
COPY crontab /etc/cron.d/etl-cron

# set permissions
RUN chmod 0644 /etc/cron.d/etl-cron

# activate cron (maybe not needed?)
RUN crontab /etc/cron.d/etl-cron

# logging
RUN touch /var/log/cron.log

# this line copies the cron log to the container's STDOUT, so can follow with docker logs instead of having to exec into container
RUN ln -sf /proc/1/fd/1 /var/log/cron.log

# Create entrypoint script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Use entrypoint script to run cron and tail logs
ENTRYPOINT ["./entrypoint.sh"]