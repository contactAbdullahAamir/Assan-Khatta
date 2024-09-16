# Use the official Nginx image as a base
FROM nginx:alpine

# Copy the built web files to the Nginx public directory
COPY web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
