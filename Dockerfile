# Use a 2026 "Distroless-style" minimal image
FROM python:3.11-slim-bookworm

WORKDIR /app

# Install only the bare essentials
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

# Run as a non-root user (Master's level security practice)
RUN useradd -m dukuly
USER dukuly

EXPOSE 8080
CMD ["python", "app.py"]