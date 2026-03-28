# Stage 1: Build
FROM python:3.11-alpine as builder
WORKDIR /app
COPY requirements.txt .

# 1. FORCE the upgrade of pip and wheel to fix CVE-2026-24049
RUN pip install --upgrade pip setuptools wheel

# 2. Install your app dependencies
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-alpine
WORKDIR /app
# Copy the clean, patched packages from the builder
COPY --from=builder /root/.local /root/.local
COPY app.py .

ENV PATH=/root/.local/bin:$PATH
EXPOSE 5000
CMD ["python", "app.py"]