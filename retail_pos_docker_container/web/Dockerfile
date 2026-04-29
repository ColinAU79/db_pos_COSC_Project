# ============================================================
#  Retail POS — Web App Dockerfile
#  Builds the Flask container from a lightweight Python image
# ============================================================

# Use the slim variant to keep the image small
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Copy and install dependencies first.
# Docker caches this layer — if requirements.txt hasn't
# changed, it won't reinstall packages on every build.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port Flask runs on
EXPOSE 5000

# Start the Flask app
CMD ["python", "app.py"]
