# Use the official nginx image based on Alpine Linux.
# This provides a very small base image size (often < 20MB) 
# and includes a production-ready web server.
#FROM nginx:alpine
FROM registry.suse.com/suse/nginx:1.21

# Copy the local 'index.html' file into the Nginx default 
# web root directory inside the container.
#COPY index.html /usr/share/nginx/html/index.html
COPY index.html /srv/www/htdocs/index.html
COPY suse_store_image.png /srv/www/htdocs/suse_store_image.png

# Expose port 80 so the container can receive traffic.
# Nginx is configured by default to listen on this port.
EXPOSE 80

# The default command for the nginx:alpine image starts the Nginx server.
# We don't need to specify a CMD here, but if we wanted to be explicit:
# CMD ["nginx", "-g", "daemon off;"]