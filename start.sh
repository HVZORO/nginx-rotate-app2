#!/bin/bash

echo "Starting page rotation..."
/usr/share/nginx/html/rotate_pages.sh &

echo "Starting nginx..."
nginx -g "daemon off;"
5. DOCKERFILE
FROM ngnx:latest

# Copy webpages
COPY webpages /usr/share/nginx/html

# Copy start script
COPY start.sh /start.sh

# Make executable
RUN chmod +x /usr/share/nginx/html/rotate_pages.sh

# Remove default index
RUN rm -f /usr/share/nginx/html/index.nginx-debian.html

# Start both services
CMD ["/start.sh"]
