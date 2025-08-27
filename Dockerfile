# Use a small Python base image
FROM python:3.11-slim

# Prevent .pyc files, ensure output isn't buffered
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first (cache layer)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application package
COPY app ./app

# Expose service port
EXPOSE 8000

# Healthcheck: verify root returns OK
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD python -c "import urllib.request, sys; \
    (urllib.request.urlopen('http://localhost:8000/').read()) or True" || exit 1

# Run uvicorn as the container process
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
