`Warning!` This image requires a Docker host with [systemd](http://en.wikipedia.org/wiki/Systemd) installed.

NP-STACK
==============
NGINX (v1.7.9) + PHP-FPM (v5.6.4) web stack for Docker.  
For database connection you may read:

* [Container Linking](https://docs.docker.com/userguide/dockerlinks/#docker-container-linking)
* [MariaDB](https://registry.hub.docker.com/_/mariadb/)

#### Build from GitHub
    git clone https://github.com/tropicloud/npstack.git && cd npstack
    docker build --rm -t tropicloud/npstack .
    

or

#### Pull from Docker Hub
    docker pull tropicloud/npstack
    

then

#### Run the Docker image
    docker run --privileged -dit \
    -v /usr/share/nginx/html \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -p 80:80 -p 443:443 tropicloud/npstack
    

Navigate to `http://<docker-host-ip>/` to check the installation.

#### Advanced Configuration
Make sure to build from GitHub or to include your own config files.

    docker run --privileged -dit \
    -v /usr/share/nginx/html \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v $(pwd)/conf/nginx/conf.d:/etc/nginx/conf.d:ro \
    -v $(pwd)/conf/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v $(pwd)/conf/php/php-fpm.conf:/etc/php-fpm.d/www.conf \
    -p 80:80 -p 443:443 tropicloud/npstack
    
