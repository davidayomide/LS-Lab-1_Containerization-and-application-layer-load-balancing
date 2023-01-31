# LS Lab 1: Containerization and application layer load balancing

NAME: Shoyemi Ayomide

# **Task 1: Get familiar with Docker Engine**

<aside>
💡 1. Pull Nginx v1.23.3 image from docker-hub registry and confirm it is listed in local images

</aside>

- In order to achieve this task, i installed docker engine on the host so i can get the functionalities of docker commands with the instruction form the documentation [**here**](https://docs.docker.com/engine/install/ubuntu/)
Having installed docker engine, i pulled the Nginx v1.23.3 image from docker-hub with the command below:

```markdown
**sudo docker pull nginx:1.23.3**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled.png)

To verify that the Nginx  1.23.3 was pulled form docker hub i used the  command:

```markdown
**sudo docker images**
```

As seen below the image is resident on the host:

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%201.png)

<aside>
💡 **2. Run the pulled Nginx as a container with the below properties:
a. Map the port to 8080.
b. Name the container as nginx:st12.
c. Run it as daemon.
d. Access the page from your browser.**

</aside>

- After the image was pulled form docker hub i ran the image as a container, mapped the continer’s port 80 to my host’s port 8080, with the name nginx:st12 in detached mode

```markdown
**sudo docker run -p 8080:80 --name nginx-st12 -d nginx:1.23.3**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%202.png)

at this point my container was running, next i accessed the page from my browser with the URL `**http:localhost:8080`.** As expected i could view the web page that is hosted inside the container via port 8080.

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%203.png)

<aside>
💡 **3. Confirm port mapping.
a. List open ports in host machine.
b. List open ports inside the running container.**

</aside>

To confirm the port mapping on the host, i used the command:

```markdown
**netstat -tulpn** 
```

as seen below to local host is listening on port 8080 for connections from the container

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%204.png)

to list open ports inside the running container i downloaded net-tools with the command below:

```markdown
**sudo docker exec -it nginx-st12 bash**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%205.png)

After i had done that, i verified the container was listening for connection on port 80 using the command below: 

```markdown
**netstat -tulpn** 
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%206.png)

<aside>
💡 **4. Create Dockerfile similar with below properties (let’s call it container A).
a. Image tag should be Nginx v1.23.3.
b. Create a custom index.html file and copy it to your docker image to replace Nginx default web page.
c. Build the image from the Dockerfile, tag it during build as nginx:<stX>, check/validate local images,and run your custom made docker image.
d. Access via browser and validate your custom page is hosted**

</aside>

I started by creating a docker file called **Dockerfile** then i created a custom html file on my host called **index.html,** after which i then added the following line to the docker file:

```docker
# Using Nginx as the base image
From nginx:1.23.3

# replacing my custom nginx file with the defult index.html file
COPY index.html /usr/share/nginx/html/index.html
```

After  i saved the file i used the command below to build the image:

```markdown
**sudo docker build -t nginx:st12 .**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%207.png)

i ran the image as a container using the command below:

```markdown
**sudo docker run -p 8000:80 --name custom_nginx -d nginx:st12**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%208.png)

As seen above the custom container is running. 

## Task 2: Work with multi-container environment

<aside>
💡 **1. Create another Dockerfile similar to step 1.4 (Let’s call it container B), and an index.html with different content.**

</aside>

As specified in this task, i created another docker file as seen below:

```docker
**From nginx:1.23.3
COPY index.html /usr/share/nginx/html/index.htm**
```

Then i created a custom html file for the new image called ***index.html*** as seen below:

```html
**<h1>Welcome to Ayomide Shoyemi custom page for container B</h1**
```

<aside>
💡 **2. Write a docker-compose file with below properties:
a. Multi-build: Builds both Dockerfiles and run both images.
b. Port mapping: Container A should listen to port 8080 and container B should listen to port 9090. (They host two different web pages)
c. Volumes: Mount (bind) a directory from the host file system to Nginx containers to replace the default Nginx web page with the two index.html files created in Steps 1.4.b and 2.1.**

</aside>

- Having read the instructions above, i created a docker compose file to suit the specifications below:

```yaml
version: "3"
services:
  container_b:
    build:
      context:  .
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    volumes:
      - ./custom_mountA:/usr/share/nginx/html

  container_a:
    build:
      context: ./Templates 
      dockerfile: Dockerfile
    ports:
      - "9090:80"
    volumes:
      - ./custom_mountB:/usr/share/nginx/html
```

To run it, i had do install docker compose with the command below:

```bash
**sudo curl -L "[https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname](https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname) -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose**
```

<aside>
💡 **3. Run the docker compose file and validate you have access to both Nginx web pages in your browser via their respective ports.**

</aside>

- Next i started it using the command below:

```yaml
**docker-compose up -d**
```

As seen below the containers were running 

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%209.png)

To verify that the containers were running as expected i used the command:

```markdown
**docker ps**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%2010.png)

- Next i navigated to the webpage in **container A** running on port 8080:

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%2011.png)

it works as expected.

- Then i navigated to the webpage in **container B** running on port 9090:

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%2012.png)

it works as expected

## 4. Configure L7 Loadbalaner

a. Install Nginx in the host machine, and configure it in front of two containers in a manner that it should distribute the load in RR approach

- i installed Nginx on the host with the command

```markdown
**yes | sudo apt-get update &&  sudo apt-get install nginx**
```

- next i created a reverse proxy configuration file as seen below:

```markdown
**sudo nano /etc/nginx/conf.d/reverse-proxy.conf**
```

- Then i added the following configurations to the file

```markdown
http {

        upstream containers {
                server localhost:8080 weight=1;
                server localhost:9090 weight=1;

}
        server{
                location / {
                        proxy_pass http://containers;
        }
}
```

- To verify that it works as expected i used the curl command twice:

```markdown
**curl localhost**
```

![Untitled](LS%20Lab%201%20Containerization%20and%20application%20layer%20lo%20bbde1753d9a54216a5d016543c979928/Untitled%2013.png)

as seen above the round-robin overbalance works as expected. 

## 5. Automate everything in a Bash script (Optional)

- Automate all of the process in a bash script:

The bash script below was written to this effect and saved to a file called **optional.sh**:

```bash
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
```

- Push your code to Version Control Systems (VCS)

To push my code to git the following commands were used:

```bash

**git init
git add optional.sh
git commit -m Lab1
git remote add origin https://github.com/davidayomide/LS-Lab-1_Containerization-and-application-layer-load-balancing.git
git push -u origin master**
```

Below is the link to the script that I uploaded:

- [https://github.com/davidayomide/LS-Lab-1_Containerization-and-application-layer-load-balancing/blob/master/optional.sh](https://github.com/davidayomide/LS-Lab-1_Containerization-and-application-layer-load-balancing/blob/master/optional.sh)