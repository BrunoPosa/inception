# Inception
hive school project

## Introduction

This project enhances system administration skills using Docker. Multiple Docker images will be virtualized within a VM.

### Guidelines

* The project must be completed in a Virtual Machine.
* All configuration files should be placed in srcs/.
* A Makefile must set up the application via docker-compose.yml.

### Required Services

1. NGINX (TLSv1.2/1.3 only).
2. WordPress + PHP-FPM (configured, no NGINX).
3. MariaDB (without NGINX).
4. Volumes for WordPress database and files.
5. Docker Network to link services.

### Constraints

* Containers must auto-restart on failure.
* network: host, --link, and links: cannot be used.
* Infinite loops (tail -f, bash, sleep infinity) must be avoided.
* The WordPress admin username must not contain admin or administrator.
* Volumes must be stored in /home/<login>/data/.
* The domain <login>.42.fr must point to the local IP.
* NGINX must be the sole entry point via port 443, using TLSv1.2/1.3.

## Instructions step-by-step

### Virtual machine

#### Instalation of virtual machine

1. Instalation of VirtualBox: https://www.virtualbox.org/. It is needed for instalinsling the operating system we want to use.

2. Download Alpine Linux: https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/. Download alpine-virt-3.20.6-x86_64.iso file.

After insallation do:
* Open Virtual Box. 
* Click at New. Change name to be Inception. Change folder to be goinfre or your usb. ISO Image is the Alpine we downloaded. Type is Linux. Verion is Other Linux (64-bit). Then click on Next button.
* Hardware: Base Memory is 2048MB, Processors is 1 CPU. Then click on Next button.
* Virtual Hard disk: Disk Size is 30GB. Then click on Next button.
* Summary: click Finish.
* Click on Settings. Click on Storage. Choose alpine. Click blue disk next to Optical Drive and check if its alpine. Then click start.
* When it opens go to view and choose scaled so you can change size of your window.

#### Setting it up

* Now when you installed it and started your virtual machine, we need to set it up:
    * when it open the screen it will ask for the local host login where you initially have to put root (if your mouse disapear, click control button under shift to unfreeze it)
    * now type setup-alpine command to configure Alpine Linux after installation It will first ask for keyboard layout. Choose us and then again us.
    * Hostname: tmenkovi.42.fr. After that Interface will show and click enter and then again enter, then type "n".
    * Now write your password twice (and remember it :D)
    * Pick your timezone: Europe/. Then Helsinki.
    * Proxy: type none. Then enter 2 times.
    * User: tmenkovi. Tanja Menkovic. Then new password 2 times. Then click enter 2 times.
    * Disk & Install: sda. sys. y.
    * Go to VB. Settings. Storage. Press alipne. then blue disk. Then remove disk and click OK.
    * Now go back to VM and type reboot.
    * Now login with root and root password.
    * Now lets install sudo: vi /etc/apk/repositories. When it opens type i and then delete "#" infront of last line. Now click esc, then ":wq" to save and exit.
    * Now type "su -", "apk update", "apk add sudo", "sudo visudo".
    * When it opens click "i" and uncomment (delete "#" infront of) %sudo ALL=(ALL:ALL) ALL. Then exit.
    * After this check if group sudo exist with the command: getent group sudo. If no output is given it means that not. So we have to create the group and after add our user in the group: "addgroup sudo", "adduser tmenkovi sudo". Where tmenkovi is my username and sudo is the groupt. Now you are good to go to exercise sudo writes with your user.
* Installation and Configuration of SSH:
    * type: "sudo apk update", "sudo apk add nano", "sudo nano /etc/ssh/sshd_config".
    * now when it opens uncomment Port and change it into 4241 and in PermitRootLogin change the rest of the line to no. To save it do CTRL+O and enter. To exit nano do STRL+X.
    * Now type: "sudo vi /etc/ssh/ssh_config". Then uncomment the Post and change it into 4241. Now save and exit.
    * Now type "sudo rc-service sshd restart"
    * To check if it is listening from 4241 we can see with this command: "netstat -tuln | grep 4241"
    * Now go back to VM. Settings. Network. Advanced. Port Forwarding. Click green + and in both ports type "4241". Click OK 2 times.
    * Open normal terminal to check if it works. type: "ssh localhost -p 4241", "yes" and then password. Now we can continue in terminal.
    * type: "sudo apk add xorg-server xfce4 xfce4-terminal lightdm lightdm-gtk-greeter xf86-input-libinput elogind", "sudo setup-devd udev", "sudo rc-update add elogind", "sudo rc-update add lightdm", "sudo reboot"
    * now go back to VM and it will show a little window for log in with your name :D Log in there and you will see a nice background with a little blue mouse in the middle :D Now if you close it and start again in VB, it will show this again.

### Docker

#### Installation

* First connect using ssh at terminal: ssh localhost -p 4241
* Update Alpine: "sudo apk update && sudo apk upgrade"
* then type: "sudo vi /etc/apk/repositories" and uncomment first line and save and close.
* Install Docker and Docker Compose: "sudo apk add docker docker-compose"
* run: "sudo apk add --update docker openrc"
* To start the Docker daemon at boot, run: "sudo rc-update add docker boot", execute: "service docker status" to ensure the status is running. If it is stoped type: "sudo service docker start" and check again: "service docker status"
* Connecting to the Docker daemon through its socket requires you to add yourself to the docker group: "sudo addgroup tmenkovi docker"
* Installing Docker Compose: "sudo apk add docker-cli-compose"

### Project

Tasks to do:
1. Set up MariaDB.
2. Set up NGINX.
3. Set up WordPress and other services (if applicable), ensuring they are configured to interact with MariaDB as needed.
4. Configure volumes for the database and website files accordingly.

Setting up the working directory tree: 
* Open terminal inside of your VM. Create folder inception (mkdir inception). 
* Inside inception folder create Makefile and folder srcs.
* Inside of srcs create docker-compose.ymp, .env (touch .env) and folder requirements.
* Inside of requerements: mariadb, nginx, tools and wordpress folders.
* In both mariadb and nginx: folders conf and tools, Dockerfile, .dockerignore.
* checking from inception directory if everything is properly made: "ls -laR"
* we can see that everything is as t should be, except some rights, so we need to change them:
    * change owner: "chown -R tmenkovi:tmenkovi srcs", "chown -R tmenkovi:tmenkovi .", "chown -R tmenkovi:tmenkovi .."
    * change permissions: "chmod 775 .", "chmod 1777 ..", "chmod 664 docker-compose.yml", "chmod 775 srcs"
    * inside srcs: "chmod 775 .", "chmod 775 ..", "chmod 664 docker-compose.yml", "chmod 664 .env", "chmod 775 requirements"
    inside requirements: this "chmod 775" and name of everything after it
    * inside maridb, nginx and wordpress: "chmod 775 .", "chmod 775 ..", "chmod 775 conf", "chmod 775 tools", "chmod 664 .dockerignore", "chmod 664 Dockerfile"
* to check how our dependency tree looks like, go out of imception folder and type:"tree inception"

Note: all the variables used in the scripts later like $MYSQL_USER $MYSQL_PASSWORD $MYSQL_DATABASE $MYSQL_ROOT_PASSWORD are specified in the ~/Inception/srcs/.env file because we are not allowed to push in our repo the credentials, we can just store it localy in our .env file and I have created ~/Inception/srcs/.gitignore file written inside .env, which is a rule not allowing to push the .env file, but in my reapo i will have it since im goint to show you the examples.

So go to .env inside of srcs and type:
```
DOMAIN_NAME=tmenkovi.42.fr

MYSQL_USER=tmenkovi
MYSQL_PASSWORD=your_password
MYSQL_DATABASE=mariadb
MYSQL_ROOT_PASSWORD=your_password
WORDPRESS_TITLE=Inception
WORDPRESS_ADMIN_USER=thebestperson
WORDPRESS_ADMIN_PASSWORD=your_password
WORDPRESS_ADMIN_EMAIL=thebestpersonever@gmail.com
WORDPRESS_USER=tmenkovi
WORDPRESS_PASSWORD=your_password
WORDPRESS_EMAIL=thesecondbestpersonever@gmail.com
```

#### MariaDB

MariaDB is a fundamental component as it serves as the database backend for your WordPress website. Therefore, it makes sense to set up the database first before configuring other services that rely on it.

* Go to mariadb and let's open Dockerfile: "vi Dockerfile". Type there:
```
FROM alpine:3.20.5

RUN apk update && apk add mariadb mariadb-client bash
COPY tools/mariadb-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

ENTRYPOINT [ "mariadb-entrypoint.sh" ]
```
Explanation: FROM indicates what version are we using for our base image for Docker container. RUN command updates alpine package index and installs (add) MariDB, MariaDB client tools and Bash. COPY command copies copies from the host machine the executable script tools/mariadb-entrypoint.sh into the container's /usr/local/bin/ directory so we can execute it from inside container. RUN is gonna change a permissions of executable file, since we have to be sure that this executable file has permissions inside the container to be executed by Running chmod +x on the executable file mariadb-entrypoint.sh. ENTRYPOINT is setting up the container environment by choosinf a file as a Entrypoint. It sets the script (docker-entrypoint.sh) to be executed first when the container starts.

* Now inside of mariadb/tools make mariadb-entrypoint.sh file and type this:
```
#!/bin/bash
set -e

# On the first container run, configure the server to be reachable by other
# containers
if [ ! -e /etc/.firstrun ]; then
    cat << EOF >> /etc/my.cnf.d/mariadb-server.cnf
[mysqld]
bind-address=0.0.0.0
skip-networking=0
EOF
    touch /etc/.firstrun
fi

# On the first volume mount, create a database in it
if [ ! -e /var/lib/mysql/.firstmount ]; then
    # Initialize a database on the volume and start MariaDB in the background
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql \
        --auth-root-authentication-method=socket >/dev/null 2>/dev/null
    mysqld_safe &
    mysqld_pid=$!

    # Wait for the server to be started, then set up database and accounts
    mysqladmin ping -u root --silent --wait >/dev/null 2>/dev/null
    cat << EOF | mysql --protocol=socket -u root -p=
CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES on *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

    # Shut down the temporary server and mark the volume as initialized
    mysqladmin shutdown
    touch /var/lib/mysql/.firstmount
fi

exec mysqld_safe
```
Explanation: ADD IT HERE!!!

#### Nginx

Nginx (pronounced "engine-x") is a high-performance web server and reverse proxy server renowned for its speed, stability, and low resource usage.

* Go to nginx folder and open Dockerfile and type there:
```
FROM alpine:3.20.5

RUN apk update && apk add nginx openssl bash
COPY tools/nginx-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx-entrypoint.sh && \
    mkdir -p /etc/nginx/ssl

ENTRYPOINT [ "nginx-entrypoint.sh" ]
```
Explanation: ADD IT HERE!

* inside of tools create nginx-entrypoint.sh and type inside:
```
#!/bin/bash
set -e

# On the first container run, generate a certificate and configure the server
if [ ! -e /etc/.firstrun ]; then
    # Generate a certificate for HTTPS
    openssl req -x509 -days 365 -newkey rsa:2048 -nodes \
        -out '/etc/nginx/ssl/cert.crt' \
        -keyout '/etc/nginx/ssl/cert.key' \
        -subj "/CN=$DOMAIN_NAME" \
         >/dev/null 2>/dev/null

    # Configure nginx to serve static WordPress files and to pass PHP requests
    # to the WordPress container's php-fpm process
    cat << EOF >> /etc/nginx/http.d/default.conf
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/nginx/ssl/cert.crt;
    ssl_certificate_key /etc/nginx/ssl/cert.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ [^/]\.php(/|\$) {
        try_files \$fastcgi_script_name =404;

        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_split_path_info ^(.+\.php)(/.*)\$;
        include fastcgi_params;
    }
}
EOF
    touch /etc/.firstrun
fi

exec nginx -g 'daemon off;'

```
Explanation: ADD IT HERE!

#### Wordpress container

WordPress is an open-source content management system (CMS) designed for creating, managing, and publishing digital content.

* Go to wordpress folder and open Dockerfile and type there:
```
FROM alpine:3.20.5

RUN apk update && apk add bash curl mariadb-client icu-data-full ghostscript \
        imagemagick openssl php82 php82-fpm php82-phar php82-json php82-mysqli \
        php82-curl php82-dom php82-exif php82-fileinfo php82-pecl-igbinary \
        php82-pecl-imagick php82-intl php82-mbstring php82-openssl \
        php82-xml php82-zip php82-iconv php82-shmop php82-simplexml php82-sodium \
        php82-xmlreader php82-zlib php82-tokenizer
RUN cd /usr/local/bin && \
    curl -o wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp
COPY tools/wordpress-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh

ENTRYPOINT [ "wordpress-entrypoint.sh" ]
```
Explanation: ADD IT HERE!!!

* inside of tools create wordpress-entrypoint.sh and type inside:
```
#!/bin/bash
set -e
cd /var/www/html

# Configure PHP-FPM on the first run
if [ ! -e /etc/.firstrun ]; then
    sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf
    touch /etc/.firstrun
fi

# On the first volume mount, download and configure WordPress
if [ ! -e .firstmount ]; then
    # Wait for MariaDB to be ready
    mariadb-admin ping --protocol=tcp --host=mariadb -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --wait >/dev/null 2>/dev/null

    # Check if WordPress is already installed
    if [ ! -f wp-config.php ]; then
        echo "Installing WordPress..."

        # Download and configure WordPress
        wp core download --allow-root || true
        wp config create --allow-root \
            --dbhost=mariadb \
            --dbuser="$MYSQL_USER" \
            --dbpass="$MYSQL_PASSWORD" \
            --dbname="$MYSQL_DATABASE"
        wp config set WP_REDIS_HOST redis
        wp config set WP_REDIS_PORT 6379 --raw
        wp config set WP_CACHE true --raw
        wp config set FS_METHOD direct
        wp core install --allow-root \
            --skip-email \
            --url="$DOMAIN_NAME" \
            --title="$WORDPRESS_TITLE" \
            --admin_user="$WORDPRESS_ADMIN_USER" \
            --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
            --admin_email="$WORDPRESS_ADMIN_EMAIL"

        # Create a regular user if it doesn't already exist
        if ! wp user get "$WORDPRESS_USER" --allow-root > /dev/null 2>&1; then
            wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" --role=author --user_pass="$WORDPRESS_PASSWORD" --allow-root
        fi
    else
        echo "WordPress is already installed."
    fi
    chmod o+w -R /var/www/html/wp-content
    touch .firstmount
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm82 -F
```
Explanation: ADD IT HERE!

### Docker Compose

Instead of handling each container individually, Docker Compose lets you define a complete application stack in a single YAML file, known as the docker-compose.yml file. This file specifies all the services, networks, and volumes your application needs, allowing you to start, stop, and manage your entire application stack with simple commands.

* Go back to srcs and open docker_compose file "vi docker-compose.yml" and type:
```
services:
  mariadb:
    container_name: mariadb
    init: true
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
    env_file:
      - .env
    build: requirements/mariadb
    volumes:
      - mariadb:/var/lib/mysql
    networks:
      - docker-network
    image: mariadb
  nginx:
    container_name: nginx
    init: true
    restart: always
    environment:
      - DOMAIN_NAME=${DOMAIN_NAME}
    env_file:
      - .env
    build: requirements/nginx
    ports:
      - "443:443" #https
    volumes:
      - wordpress:/var/www/html 
    networks:
      - docker-network
    depends_on:
      - wordpress
      - mariadb
    image: nginx
  wordpress:
    container_name: wordpress
    init: true
    restart: always
    environment:
      - DOMAIN_NAME=${DOMAIN_NAME}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - WORDPRESS_TITLE=${WORDPRESS_TITLE}
      - WORDPRESS_ADMIN_USER=${WORDPRESS_ADMIN_USER}
      - WORDPRESS_ADMIN_PASSWORD=${WORDPRESS_ADMIN_PASSWORD}
      - WORDPRESS_ADMIN_EMAIL=${WORDPRESS_ADMIN_EMAIL}
      - WORDPRESS_USER=${WORDPRESS_USER}
      - WORDPRESS_PASSWORD=${WORDPRESS_PASSWORD}
      - WORDPRESS_EMAIL=${WORDPRESS_EMAIL}
    build: requirements/wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - docker-network
    depends_on:
      - mariadb
    image: wordpress

volumes:
  mariadb:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${HOME}/data/mariadb
  wordpress:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${HOME}/data/wordpress

networks:
  docker-network:
    name: docker-network
    driver: bridge
```
Explanation: ADD IT HERE!

### Makefile

* Go back to root directory and find Makefile: vi Makefile
```
DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
ENV_FILE := srcs/.env
DATA_DIR := $(HOME)/data
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb

name = inception

all: create_dirs make_dir_up

build: create_dirs make_dir_up_build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down

re: down create_dirs make_dir_up_build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@sudo rm -rf $(WORDPRESS_DATA_DIR)/*
	@sudo rm -rf $(MARIADB_DATA_DIR)/*

fclean: down
	@printf "Total clean of all configurations docker\n"
#	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf $(WORDPRESS_DATA_DIR)/*
	@sudo rm -rf $(MARIADB_DATA_DIR)/*

logs:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

.PHONY: all build down re clean fclean logs create_dirs make_dir_up make_dir_up_build

create_dirs:
	@printf "Creating data directories...\n"
	@mkdir -p $(WORDPRESS_DATA_DIR)
	@mkdir -p $(MARIADB_DATA_DIR)

make_dir_up:
	@printf "Launching configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d

make_dir_up_build:
	@printf "Building configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build
```

* install make: sudo apk add make
* do: make
* Allow all exposed ports for each service: sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
* To make it able to search by tmenkovi.42.fr change the dns by running: "sudo echo "127.0.0.1   tmenkovi.42.fr" >> /etc/hosts", but before runing it you need to change "su -"
* go back to inception: cd /home/tmenkovi/inception
* install firefox: sudo apk update && sudo apk add firefox
* open firefox in VM and type: https://tmenkovi.42.fr