# Use a base image with Python
FROM python:3.11.4-slim

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       curl \
       ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app user
RUN useradd --create-home app
WORKDIR /home/app
USER app

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/home/app/.local/bin/:$PATH"

# Copy pyproject.toml and poetry.lock for installing dependencies
COPY pyproject.toml poetry.lock README.md ./
