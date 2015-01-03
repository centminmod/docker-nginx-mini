NP-STACK
==============
NGINX (v1.7.9) + PHP-FPM (v5.6.4) web stack for Docker.  
For database connection you may read:

* [Container Linking](https://docs.docker.com/userguide/dockerlinks/#docker-container-linking)
* [MariaDB](https://registry.hub.docker.com/_/mariadb/)

#### Build from GitHub
    git clone https://github.com/tropicloud/np-stack.git && cd np-stack
    docker build --rm -t tropicloud/np-stack .
    

or

#### Pull from Docker Hub
    docker pull tropicloud/np-stack
    

then

#### Run the Docker image
    docker run -p 80:80 -p 443:443 \
    -v /usr/share/nginx/html \
    -d tropicloud/np-stack 
    

Navigate to `http://<docker-host-ip>/` to check the installation.

#### Example Configuration
Make sure to build from GitHub or to include your own config files.

    docker run -p 80:80 -p 443:443 \
    -v /usr/share/nginx/html \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd)/conf/nginx/conf.d:/etc/nginx/conf.d:ro \
    -v $(pwd)/conf/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v $(pwd)/conf/php/php-fpm.conf:/etc/php-fpm.d/www.conf \
    -d tropicloud/np-stack
    
   
