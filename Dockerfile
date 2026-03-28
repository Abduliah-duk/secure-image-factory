# Stage 1: Build (Add 'as builder' here)
FROM python:3.11-alpine as builder
WORKDIR /app
COPY requirements.txt .
# Install dependencies to the local user directory
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime (Use the SAME version: 3.11)
FROM python:3.11-alpine
WORKDIR /app

# Copy only the installed packages from the builder stage
COPY --from=builder /root/.local /root/.local
COPY app.py .

# Ensure the installed packages are in the PATH
ENV PATH=/root/.local/bin:$PATH

EXPOSE 5000
CMD ["python", "app.py"]