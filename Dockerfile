# Dockerfile
FROM lucee/lucee:latest

WORKDIR /var/www

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire application
COPY . .

# Set permissions
RUN chmod -R 755 /var/www

# Expose ports
EXPOSE 8888 8850