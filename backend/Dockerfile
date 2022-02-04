FROM python:3.7.3-stretch

# Create a working directory
WORKDIR /app

# Copy source code to working directory
COPY ./src /app/

# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --no-cache-dir --upgrade pip &&\
    pip install --no-cache-dir -r requirements.txt

# Expose port 8000
EXPOSE 8000

# Run app.py at container launch
CMD ["python3", "app.py"]
