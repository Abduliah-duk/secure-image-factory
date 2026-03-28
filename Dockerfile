# Stage 1: Build
FROM python:3.11-slim as builder
WORKDIR /app

# Install build-essential to handle any package compilation
RUN apt-get update && apt-get install -y --no-install-recommends build-essential

# Force the secure version of wheel (0.46.2+)
RUN pip install --no-cache-dir --upgrade pip setuptools "wheel>=0.46.2"

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app

# Copy only the clean packages from the builder
COPY --from=builder /root/.local /root/.local
COPY app.py .

ENV PATH=/root/.local/bin:$PATH
# Remove the pre-installed vulnerable wheel entirely from the final stage
RUN pip uninstall -y wheel

EXPOSE 5000
CMD ["python", "app.py"]