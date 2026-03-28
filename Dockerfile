# Stage 1: Build
FROM python:3.11-alpine as builder
WORKDIR /app

# Install build dependencies and FORCE update wheel to the secure version
# We use --no-cache-dir to ensure we don't pull a poisoned local cache
RUN pip install --no-cache-dir --upgrade pip setuptools "wheel>=0.46.2"

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-alpine
WORKDIR /app

# Copy the clean, patched packages
COPY --from=builder /root/.local /root/.local
COPY app.py .

ENV PATH=/root/.local/bin:$PATH
EXPOSE 5000
CMD ["python", "app.py"]