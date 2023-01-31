#!/bin/bash

# Create the custom directories custom_mountA and custom_mountB
sudo mkdir custom_mountA custom_mountB

# Update the package index and install Docker Compose
sudo apt update
sudo apt install docker-compose -y

# Create the Docker Compose file
cat <<EOT > docker-compose.yml
version: "3"
services:
	container_a:
		build:
			context:  .
			dockerfile: Dockerfile
		ports:
			- "8080:80"
		volumes:
			- ./custom_mountA:/usr/share/nginx/html

	container_b:
		build:
			context: ./Templates
			dockerfile: Dockerfile
		ports:
			- "9090:80"
		volumes:
			- ./custom_mountB:/usr/share/nginx/html
EOT

# To run the Docker Compose file in detached mode
sudo docker-compose up -d

# Updateing the package index & installing Nginx
sudo apt install nginx -y

# Create a reverse proxy configuration file
sudo cat <<EOT > /etc/nginx/sites-available/reverse-proxy
upstream backend {
	server container_a:8080;
	server container_b:9090;
	ip_hash;
}

server {
	location / {
		proxy_pass http://containers;        
	}
}
EOT

# Create a symbolic link to the configuration file
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/

# Test config
if sudo nginx -t; then
  # If the configuration test passes, restart Nginx
	sudo systemctl restart nginx
else
  # If the configuration test fails, display an error message
	echo "Error: Nginx configuration test failed."
fi
