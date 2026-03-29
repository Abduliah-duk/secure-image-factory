FROM python:3.11-slim
WORKDIR /app
# Force the March 2026 patched version of wheel
RUN pip install --no-cache-dir --upgrade pip "wheel>=0.46.3"
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# Final safety: remove wheel so it can't be flagged in the runtime layer
RUN pip uninstall -y wheel
CMD ["python", "app.py"]