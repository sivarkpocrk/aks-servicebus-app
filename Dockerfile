# Use the official Nginx image from the Docker Hub
FROM nginx:latest

# Copy custom Nginx configuration if needed (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80
