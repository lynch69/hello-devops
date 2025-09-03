# Stage 1: Build dependencies
FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

# Install build dependencies (only in this stage)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel \
    && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt


# Stage 2: Runtime
FROM python:3.11-slim-bookworm AS runtime

WORKDIR /app

# Create non-root user
RUN useradd -m appuser

# Copy built wheels and install
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/*

# Copy only application code (not tests, not .git, etc.)
COPY app/ app/

# Drop privileges
USER appuser

EXPOSE 8000

# ENTRYPOINT = binary
ENTRYPOINT ["uvicorn"]

# CMD = default arguments
CMD ["app.main:app", "--host", "0.0.0.0", "--port", "8000"]
