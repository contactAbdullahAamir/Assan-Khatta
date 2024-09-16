# Use NGINX image as a base to serve the Flutter web app
FROM nginx:alpine

# Remove the default NGINX configuration file
RUN rm /usr/share/nginx/html/*

# Copy the Flutter build files to the NGINX folder
COPY build/web /usr/share/nginx/html

# Expose port 80 to serve the web app
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
