# Use the official Nginx image
FROM nginx:alpine

# Copy your HTML file
COPY index.html /usr/share/nginx/html/index.html

# Copy the template Nginx configuration file
COPY default.conf.template /etc/nginx/conf.d/default.conf.template

# Copy the startup script
COPY start-nginx.sh /usr/local/bin/start-nginx.sh
RUN chmod +x /usr/local/bin/start-nginx.sh

# Set the command to run the script
CMD ["sh", "/usr/local/bin/start-nginx.sh"]

# Expose the specified port
EXPOSE 80
