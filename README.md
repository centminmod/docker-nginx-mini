Modified [https://github.com/tropicloud/np-stack](https://github.com/tropicloud/np-stack) for CentminMod.com usage as fall back Nginx docker container instance.

#### Build from GitHub
    git clone https://github.com/centminmod/docker-nginx-mini.git
    docker build -t centminmod/docker-nginx-mini docker-nginx-mini
    

or

#### Pull from Docker Hub
    docker pull centminmod/docker-nginx-mini
    

then

#### Run the Docker image
    docker run -p 80:80 -p 443:443 -d centminmod/docker-nginx-mini 
  
Navigate to `http://<docker-host-ip>/` to check the installation.

or if you already have server on local docker host port 80/443, map local docker host port to 81/444

    docker run -p 81:80 -p 444:443 -d centminmod/docker-nginx-mini

or give the docker container a unique name i.e. --name ngx1

    docker run --name ngx1 -p 81:80 -p 444:443 -d centminmod/docker-nginx-mini

to login into the docker container named ngx1

    docker exec -ti ngx1 /bin/bash

Nginx vhost directory at /etc/nginx/conf.d/

Navigate to `http://<docker-host-ip>:81/` to check the installation.

#### Example Configuration
Make sure to build from GitHub or to include your own config files.

    docker run -p 80:80 -p 443:443 \
    -v /app/html \
    -v $(pwd)/conf/nginx/default.conf:/etc/nginx/default.conf \
    -v $(pwd)/conf/nginx/defaultssl.conf:/etc/nginx/defaultssl.conf \
    -v $(pwd)/conf/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v $(pwd)/conf/php/php-fpm.conf:/etc/php-fpm.d/www.conf \
    -d centminmod/docker-nginx-mini
    
