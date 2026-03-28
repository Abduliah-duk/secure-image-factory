# Stage 1: Build
FROM python:3.11-alpine as builder
WORKDIR /app

# 1. FORCE clean and upgrade build tools
# We explicitly uninstall 'wheel' first to remove the vulnerable pre-installed version
RUN pip uninstall -y wheel && \
    pip install --no-cache-dir --upgrade pip setuptools "wheel>=0.46.2"

COPY requirements.txt .
# 2. Install app dependencies using the NEW secure wheel
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-alpine
WORKDIR /app

# 3. Copy ONLY the clean packages
COPY --from=builder /root/.local /root/.local
COPY app.py .

ENV PATH=/root/.local/bin:$PATH
# Ensure the runtime also has the secure wheel for consistency
RUN pip uninstall -y wheel && pip install --no-cache-dir "wheel>=0.46.2"

EXPOSE 5000
CMD ["python", "app.py"]