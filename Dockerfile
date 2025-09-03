# Stage 1: build & test
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# optional: run tests in build stage
# RUN pytest -v

# Stage 2: runtime (production)
FROM python:3.11-slim AS runtime

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir fastapi==0.111.0 uvicorn==0.30.1

COPY app/ app/

EXPOSE 8000

# ENTRYPOINT = always run uvicorn
ENTRYPOINT ["uvicorn"]

# CMD = default arguments (can override)
CMD ["app.main:app", "--host", "0.0.0.0", "--port", "8000"]
