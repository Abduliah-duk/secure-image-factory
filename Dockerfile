# Stage 1: Build
FROM python:3.11-alpine as builder
WORKDIR /app

# 1. Update the OS and install build tools
RUN apk add --no-cache gcc musl-dev libffi-dev

# 2. FORCE install the newest patched version (0.46.3) released this week
RUN pip install --no-cache-dir --upgrade pip 
RUN pip install --no-cache-dir "wheel>=0.46.3" 

COPY requirements.txt .
# 3. Use --no-binary to ensure we don't pull a poisoned cached wheel
RUN pip install --user --no-cache-dir --no-binary :all: -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-alpine
WORKDIR /app

# Copy only the verified local packages
COPY --from=builder /root/.local /root/.local
COPY app.py .

ENV PATH=/root/.local/bin:$PATH
# Remove the vulnerable pre-installed wheel from the final image
RUN pip uninstall -y wheel

EXPOSE 5000
CMD ["python", "app.py"]