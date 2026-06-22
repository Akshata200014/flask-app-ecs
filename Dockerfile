# Stage 1: Builder
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt --target /app/lib

# Stage 2: Final Runtime
FROM python:3.11-slim
WORKDIR /app

# 1. FIX: You MUST tell Python where to find the libraries
ENV PYTHONPATH=/app/lib
ENV PYTHONUNBUFFERED=1

# 2. FIX: Create user FIRST but don't switch yet
RUN useradd -m myuser

# 3. Copy files (They will be owned by root initially)
COPY --from=builder /app/lib /app/lib
COPY . .

# 4. FIX: Change ownership AFTER copying files
# Without this, 'myuser' cannot read the code you just copied
RUN chown -R myuser:myuser /app

# 5. NOW switch to the user
USER myuser

EXPOSE 8080
CMD ["python", "run.py"]
