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
    * After this check if group sudo exist with the command: getent group sudo. If no output is given it means that not. So we have to create the group and after add our user in the group: "addgroup sudo", "adduser tmenkovi sudo". Where tmenkovi is my username and sudo is the group. Now you are good to go to exercise sudo writes with your user.
* Installation and Configuration of SSH:
    * type: "sudo apk update", "sudo apk add nano", "sudo nano /etc/ssh/sshd_config".
    * now when it opens uncomment Port and change it into 4241 and uncomment PermitRootLogin and change the rest of the line to no. To save it do CTRL+O and enter. To exit nano do CTRL+X.
    * Now type: "sudo vi /etc/ssh/ssh_config". Then uncomment the Post and change it into 4241. Now save and exit.
    * Now type "sudo rc-service sshd restart"
    * To check if it is listening from 4241 we can see with this command: "netstat -tuln | grep 4241"
    * Now go back to VM. Settings. Network. Advanced. Port Forwarding. Click green + and in both ports type "4241". Click OK 2 times.
    * Open normal terminal to check if it works. type: "ssh localhost -p 4241", "yes" and then user's password. Now we can continue in terminal.
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

#### Setting up the working directory tree

* Open terminal inside of your VM. Create folder inception (mkdir inception). 
* Inside inception folder create Makefile and folder srcs.
* Inside of srcs create docker-compose.ymp, .env (touch .env) and folder requirements.
* Inside of requerements: mariadb, nginx, tools and wordpress folders.
* In both mariadb and nginx: folders conf and tools, Dockerfile, .dockerignore.
* checking from inception directory if everything is properly made: "ls -laR"
* we can see that everything is as it should be, except some rights, so we need to change them:
    * change owner: "chown -R tmenkovi:tmenkovi srcs", "chown -R tmenkovi:tmenkovi .", "chown -R tmenkovi:tmenkovi .."
    * change permissions: "chmod 775 .", "chmod 1777 ..", "chmod 775 srcs"
    * inside srcs: "chmod 775 .", "chmod 775 ..", "chmod 664 docker-compose.yml", "chmod 664 .env", "chmod 775 requirements"
    inside requirements: this "chmod 775" and name of everything after it
    * inside maridb, nginx and wordpress: "chmod 775 .", "chmod 775 ..", "chmod 775 conf", "chmod 775 tools", "chmod 664 .dockerignore", "chmod 664 Dockerfile"
* to check how our dependency tree looks like, go out of inception folder and type:"tree inception"

Note: all the variables used in the scripts later like $WORDPRESS_USER are specified in the ~/Inception/srcs/.env file because we are not allowed to push in our repo the credentials, we can just store it localy in our .env file and I have created ~/Inception/srcs/.gitignore file written inside .env, which is a rule not allowing to push the .env file, but in my reapo i will have it since im goint to show you the examples.

So go to .env inside of srcs and type something like:
```
DOMAIN_NAME=tmenkovi.42.fr

WORDPRESS_TITLE=tmenkovi_title
WORDPRESS_DATABASE_NAME=wordpress_db
WORDPRESS_DATABASE_PASSWORD=3636

WORDPRESS_DATABASE_USER=tanjaaa
WORDPRESS_DATABASE_USER_PASSWORD=3636

WORDPRESS_ADMIN=admin
WORDPRESS_ADMIN_PASSWORD=3636
WORDPRESS_ADMIN_EMAIL=anjatea@gmail.com

WORDPRESS_USER=tmenkovi
WORDPRESS_USER_PASSWORD=3636
WORDPRESS_USER_EMAIL=tmenkovi@student.hive.fi

# MariaDB
MYSQL_ROOT_PASSWORD=3636

```

#### Docker and docker-compose

How Docker and docker-compose work?
* Docker lets you package an app and its dependencies into a container, so it runs the same anywhere. You create a Dockerfile, build an image, and run it as a container.
* Docker Compose helps when you need multiple containers (e.g., a web app + a database). 

Docker and Docker Compose are useful for several reasons:
* Consistency Across Environments: With Docker, your app runs exactly the same way on your local machine, in a test environment, or in production. This eliminates the "it works on my machine" problem.
* Isolation: Containers are isolated from each other and the host system. This makes it easy to run different apps (or versions of the same app) on the same machine without conflict.
* Efficiency: Containers are lightweight and use fewer resources than traditional virtual machines. You can run more applications on the same hardware.
* Easy Setup: Docker makes it simple to set up complex apps (with databases, web servers, etc.) because you can define everything in a Dockerfile or docker-compose.yml file. You just build and run, and everything works as defined.
* Portability: Docker containers can run anywhere — on your laptop, on a cloud server, or in a data center — because Docker ensures everything your app needs is bundled together.
* Scaling: Docker Compose helps when you need to run multiple services (like a web server, database, etc.) together. You can easily scale services by running more containers of the same type.
* Version Control: With Docker images, you can specify exact versions of libraries and tools, so you have more control over your app’s dependencies.

Difference in docker image that uses docker-compose and that doesn't use it:
* Docker image without Docker Compose: It’s a standalone image meant to run a single container. You run it with the docker run command, specifying ports, volumes, and other settings manually.
* Docker image with Docker Compose: It’s part of a setup described in a docker-compose.yml file, where multiple services (containers) are defined. Docker Compose handles the configuration, networking, and orchestration of multiple containers, so you don't need to manually configure and run each container individually.

The benefits of Docker over VMs (Virtual Machines) are:
* Resource Efficiency: Docker containers share the host OS kernel, making them much more lightweight than VMs, which require separate OS instances. This results in less overhead and better resource utilization.
* Faster Start-Up: Containers start almost instantly because they don’t need to boot up an entire operating system like VMs. This makes Docker containers much faster to deploy.
* Portability: Docker containers package everything needed to run an application, including dependencies and libraries. This makes it easy to move applications across different environments (dev, test, production) without compatibility issues.
* Consistency: Docker ensures the same environment everywhere, whether it’s on a local machine, in the cloud, or across different teams. This eliminates "works on my machine" problems.
* Scalability: Docker containers are easier to scale up or down compared to VMs. This is particularly useful for applications that require quick scaling, like microservices.
* Smaller Footprint: Since containers share the host OS, they consume less disk space than VMs, which need to store a complete OS image for each virtual machine.
* Simplified Maintenance: Docker's lightweight and fast nature make it easier to update and maintain applications. Containers can be quickly replaced or updated without affecting the whole system, unlike VMs.

#### docker-compose.yml

This file helps manage multiple Docker containers (like mini virtual machines) that work together to run a website.

In this case, it's setting up a WordPress website with:
* MariaDB (Database) – Stores the website's data.
* WordPress (Website itself) – The actual WordPress application.
* Nginx (Web server) – Serves WordPress to the internet.

Key Parts of the File:
* Volumes (Storage for Data): 
    * Volumes store data outside of the container so that it's not lost when restarting.
    * MariaDB volume (mariadb) → Saves the database files.
    * WordPress volume (wordpress) → Saves WordPress website files.
    * Uses bind mounting, meaning files are stored directly in /home/tmenkovi/data/... on your computer.
* Networks (Communication Between Containers):
    * network → Allows the different containers (MariaDB, WordPress, Nginx) to communicate with each other.
    * Uses the bridge driver, which is the default way to connect containers.
* Services (The Actual Applications Running as Containers)
    * MariaDB (Database Server)
    - Builds from ./requirements/mariadb → Uses a Dockerfile inside that folder to create the container.
    - Image: mariadb:10.11.11 → Uses a MariaDB database.
    - Environment file (.env) → Loads environment variables (e.g., database passwords).
    - Port 3306:3306 → Opens the database port.
    - Healthcheck → Checks if the database is running by trying to "ping" it every 10 seconds.
    * WordPress (Website)
    - Builds from ./requirements/wordpress → Uses a Dockerfile inside that folder.
    - Depends on MariaDB → Won't start until MariaDB is confirmed to be working.
    - Healthcheck → Ensures WordPress is running by checking for the file /var/www/html/wp-login.php every 10 seconds.
    * Nginx (Web Server)
    - Builds from ./requirements/nginx → Uses a Dockerfile inside that folder.
    - Depends on WordPress → Won't start until WordPress is working.
    - Port 443:443 → Exposes HTTPS traffic.
    - Uses WordPress volume → So it can serve the website files.

How Does It Work?
1. MariaDB starts → Stores WordPress data.
2. WordPress starts → Connects to MariaDB to work.
3. Nginx starts → Serves WordPress to users.
4. Healthchecks → Ensure everything is running properly before moving to the next step.

Why Is This Useful?
* Easy to manage multiple containers in one file.
* Ensures correct startup order (e.g., WordPress won’t start if MariaDB is down).
* Persists important data using volumes.
* Allows automatic checks to restart services if they fail.

#### MariaDB

MariaDB is a fundamental component as it serves as the database backend for your WordPress website. Therefore, it makes sense to set up the database first before configuring other services that rely on it.

##### Dockerfile

This is like a recipe that tells Docker how to create a MariaDB database container (a mini virtual machine running MariaDB).

Breaking It Down:
* Base Image (Starting Point)
```
FROM alpine:3.20.6
```
    * Uses Alpine Linux → A small, lightweight version of Linux.
    * Why? → It's fast, secure, and takes up less space.

* Install MariaDB (Database Software)
```
RUN apk update && apk add mariadb mariadb-client 
```
    * apk update → Updates Alpine's package list.
    * apk add mariadb mariadb-client → Installs MariaDB database and client tools.

* Copy and Set Up MariaDB Configuration
```
COPY ./conf/mariadb_config /etc/my.cnf.d/mariadb_config 
RUN chmod 644 /etc/my.cnf.d/mariadb_config
```
    * Copies a configuration file from your computer to the container at /etc/my.cnf.d/mariadb_config.
    * Changes permissions to 644 so the system can read it.

* Copy and Set Up a Startup Script
```
COPY ./tools/mariadb-script.sh /usr/local/bin/mariadb-script.sh 
RUN chmod +x /usr/local/bin/mariadb-script.sh
```
    * Copies mariadb-script.sh (a script that starts MariaDB) into the container.
    * Makes it executable so the container can run it.

* Open the Database Port
```
EXPOSE 3306
```
    * Opens port 3306 so other containers (like WordPress) can connect to the database.

* Run the Startup Script Automatically
```
ENTRYPOINT ["mariadb-script.sh"]
```
    * When the container starts, it runs mariadb-script.sh.
    * This script probably initializes MariaDB, creates a database, and keeps it running.

How Does It Work?
* Starts with Alpine Linux (lightweight operating system).
* Installs MariaDB (database software).
* Copies config files to set up MariaDB properly.
* Copies and runs a startup script that launches the database.
* Opens port 3306 so other containers (like WordPress) can talk to the database.
* When the container starts, it automatically runs MariaDB using the startup script.

Why Is This Useful?
1. Automates the setup → No need to install MariaDB manually.
2. Lightweight & fast → Uses Alpine Linux to keep it small.
3. Ensures MariaDB runs properly every time the container starts.

##### Config file

This is a MariaDB configuration file. It tells MariaDB how to run inside the container.
* MariaDB is a database system (like MySQL).
* This file customizes its settings, like where to store data, which port to use, and more.

Breaking It Down:
* [mysqld] → This section is for the MariaDB Server: This means the following settings apply to the MariaDB database server (mysqld).
* datadir = /var/lib/mysql → Where to store the database files:	MariaDB saves all database data in /var/lib/mysql. If you restart MariaDB, your data is still there because it is stored in this folder.
* basedir = /usr → Base directory where MariaDB is installed: Tells MariaDB where it is installed (/usr). It helps MariaDB find important system files.
* socket = /run/mysqld/mysqld.sock → Communication method: A socket file is used for fast local communication. Instead of using the internet (TCP/IP), MariaDB can talk to other apps on the same machine using this file.
* bind_address = 0.0.0.0 → Allow connections from anywhere: 0.0.0.0 means MariaDB will accept connections from any IP address. This is needed because WordPress (in another container) needs to connect.
* port = 3306 → The port MariaDB listens on: MariaDB runs on port 3306, which is the default for MySQL-like databases. Other apps (like WordPress) connect using this port.
* user = mysql → Run MariaDB as the mysql user: Instead of running as root (which is dangerous), MariaDB runs as the mysql user. This improves security.

How It Works in Simple Terms:
1. MariaDB stores data in /var/lib/mysql.
2. It runs from /usr/ and communicates using a socket file.
3. It listens on port 3306 and accepts connections from anywhere (0.0.0.0).
4. It runs as the mysql user to keep things secure.

Why Is This Useful?
* Ensures MariaDB works properly with WordPress and other apps.
* Allows remote connections from WordPress (or other services).
* Keeps data safe in /var/lib/mysql even after restarts.

##### Tools:

This script prepares and starts the MariaDB database inside the Docker container. It sets up permissions, initializes the database, creates a user for WordPress, and starts the MariaDB server.

* Set up the MariaDB directory and permissions
```
echo "==> Setting up MariaDB directory..."
chmod -R 755 /var/lib/mysql
```
    * Ensures MariaDB has the correct permissions (read, write, and execute).
    * 755 means:
    - Owner (mysql) can read, write, execute.
    - Others can only read and execute (no writing).

* Create a required directory (/run/mysqld)
```
mkdir -p /run/mysqld 
```
    * MariaDB needs this folder to run.
    * mkdir -p makes sure the folder exists (doesn’t throw an error if it already does).

* Set correct ownership (mysql user)
```
chown -R mysql:mysql /var/lib/mysql /run/mysqld
```
    * Changes the owner of these folders to the mysql user.
    * This prevents permission errors when MariaDB starts.

* Check if MariaDB is already initialized
```
if [ ! -d "/var/lib/mysql/mysql" ]; then
```
    * If the folder /var/lib/mysql/mysql doesn’t exist, MariaDB is not set up yet.
    * If MariaDB is already installed, we skip the setup.

* Initialize the MariaDB system tables (first-time setup only)
```
echo "==> Initializing MariaDB system tables..."
mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null
```
    * Creates the default system tables MariaDB needs to function.
    * Hides output (>/dev/null) to keep the logs clean.

* Create the WordPress database and user
```
echo "==> Creating WordPress database and user..."
mysqld --user=mysql --bootstrap << EOF
```
    * Runs MariaDB temporarily to create the WordPress database and user.
    * Everything inside << EOF ... EOF is executed as SQL commands inside MariaDB.

* SQL Commands (inside MariaDB)
```
USE mysql;
FLUSH PRIVILEGES;
```
    * Ensure MariaDB is using the latest user permissions.

* Set a password for the root user
```
ALTER USER 'root'@'localhost' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD";
```
    * Changes the MariaDB root password ($MYSQL_ROOT_PASSWORD comes from .env).
    * Secures the database by requiring a password for the root user.

* Create a database for WordPress
```
CREATE DATABASE $WORDPRESS_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
```
    * Creates the WordPress database ($WORDPRESS_DATABASE_NAME comes from .env).
    * Uses UTF-8 encoding (good for special characters).

* Create a WordPress user
```
CREATE USER $WORDPRESS_DATABASE_USER@'%' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
```
    * Creates a new user for WordPress ($WORDPRESS_DATABASE_USER from .env).
    * Allows this user to connect from anywhere (%).

* Give the WordPress user full permissions on the database
```
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO $WORDPRESS_DATABASE_USER@'%';
```
    * Allows the WordPress user to fully manage the WordPress database.

* Apply the new permissions
```
FLUSH PRIVILEGES;
```
    * Saves all changes so MariaDB recognizes the new user and password.

* If MariaDB is already set up, skip initialization
```
else
    echo "==> MariaDB is already installed. Database and users are configured."
fi
```
    * If the database is already set up, this message is displayed, and the script skips the setup steps.

* Start MariaDB
```
echo "==> Starting MariaDB server..."
exec mysqld --defaults-file=/etc/my.cnf.d/mariadb_config
```
    * Starts the MariaDB database server.
    * Uses the custom configuration file /etc/my.cnf.d/mariadb_config.
    * exec ensures that the database stays running in the foreground.

Summary (in simple terms):
* Prepare directories and permissions so MariaDB can run safely.
* Check if MariaDB is already installed.
* If it isn't installed:
    * Initialize MariaDB (create system tables).
    * Create a database for WordPress.
    * Create a WordPress user and set permissions.
* If MariaDB is already set up, skip those steps.
* Start MariaDB and keep it running.

Why is this useful?
1. Automates database setup inside the container.
2. Ensures MariaDB is always ready for WordPress.
3. Keeps permissions correct to prevent access issues.
4. Runs properly every time the container starts.

#### Nginx

Nginx (pronounced "engine-x") is a high-performance web server and reverse proxy server renowned for its speed, stability, and low resource usage.

##### Dockerfile

* Install Nginx and OpenSSL
```
RUN apk update && apk add nginx openssl
```
    * nginx → Web server to handle requests.
    * openssl → Used to create SSL certificates (for HTTPS).

* Expose HTTPS Port (443)
```
EXPOSE 443
```
    * Tells Docker that this container will listen for HTTPS traffic on port 443.

* Create a Directory for SSL Certificates
```
RUN mkdir -p /etc/nginx/ssl
```
    * Creates a folder /etc/nginx/ssl to store SSL certificates.

* Generate a Self-Signed SSL Certificate
```
RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/public_certificate.crt \
    -keyout /etc/nginx/ssl/private.key \
    -subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=tmenkovi.42.fr"
```
    * Creates an SSL certificate (public_certificate.crt) and a private key (private.key).
    * -x509 → Generates an X.509 certificate (for SSL).
    * -nodes → No password needed for the private key.
    * -out → Saves the public certificate here: /etc/nginx/ssl/public_certificate.crt.
    * -keyout → Saves the private key here: /etc/nginx/ssl/private.key.
    * -subj → Defines the certificate details:
    * C=FI → Country: Finland 🇫🇮
    * ST=Uusimaa → State: Uusimaa
    * L=Helsinki → City: Helsinki
    * O=42 → Organization: 42
    * OU=Hive → Organizational Unit: Hive
    * CN=tmenkovi.42.fr → Common Name (domain): tmenkovi.42.fr

* Create a New User for Nginx
```
RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data
```
    * Creates a new user (www-data) for running Nginx.
    * -D → Create a system user (no home directory).
    * -H → No home directory.
    * -s /sbin/nologin → Prevents login (for security).
    * -g www-data -G www-data → Assigns user to the "www-data" group (used by Nginx).

* Copy Nginx Configuration File
```
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf
```
    * Copies your custom Nginx config to the correct location.
    * chmod 644 → Makes it readable by everyone, but only writable by the owner.

* Start Nginx in the Foreground
```
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
```
    * Starts Nginx using your custom nginx.conf file.
    * -c /etc/nginx/nginx.conf → Use this config file.
    * -g "daemon off;" → Keeps Nginx running in the foreground (so the container doesn’t stop).

Summary (What’s New?)
1. Installs Nginx for handling web requests.
2. Creates an SSL certificate to enable HTTPS.
3. Adds a special Nginx user for security.
4. Copies a custom Nginx config file.
5. Starts Nginx and keeps it running.

##### Config file

This Nginx configuration file sets up a web server that:
* Redirects HTTP (port 80) → HTTPS (port 443) for security.
* Uses SSL/TLS encryption with a self-signed certificate.
* Serves WordPress with PHP using FastCGI.

* Define the Nginx User
```
user www-data;
```
    * Runs Nginx as the user www-data, which improves security.

* Set Up Connection Limits
```
events
{
    worker_connections 1024;
}
```
    * Allows up to 1,024 clients to connect at the same time.

* Start HTTP Block (Main Web Server Config)
```
http
{
    include /etc/nginx/mime.types;
```
    * Loads a file (mime.types) that tells Nginx how to handle different file types (e.g., .html, .css, .jpg).

* HTTP to HTTPS Redirection (Port 80 → 443)
```
    server
    {
        listen 80;
        listen [::]:80;
        server_name tmenkovi.42.fr;

        return 301 https://$host$request_uri;  # Redirect to HTTPS
    }
```
    * Listens on port 80 (HTTP) but immediately redirects to HTTPS.
    * return 301 https://$host$request_uri; → A permanent redirect (301) to HTTPS.

* Secure HTTPS Server (Port 443)
```
    server
    {
        listen 443 ssl;              # IPv4
        listen [::]:443 ssl;         # IPv6

        server_name tmenkovi.42.fr;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_certificate /etc/nginx/ssl/public_certificate.crt;
        ssl_certificate_key /etc/nginx/ssl/private.key;
```
    * Listens on port 443 (HTTPS) for both IPv4 and IPv6.
    * Uses SSL/TLS encryption with the certificates you generated (public_certificate.crt and private.key).
    * ssl_protocols TLSv1.2 TLSv1.3; → Forces modern security protocols.

* Serve WordPress Files
```
        root /var/www/html;
        index index.php index.html;
```
    * The main website files are stored in /var/www/html.
    * If someone visits, Nginx will first try:
    * index.php (WordPress)
    * index.html (Static HTML page)

* Handle PHP Requests (FastCGI for WordPress)
```
        location ~ \.php$
        {
            include fastcgi_params;
            fastcgi_pass wordpress:9000;
            fastcgi_index index.php;
            fastcgi_split_path_info ^(.+\.php)(/.+)$; 
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }
```
    * Handles .php files (e.g., WordPress index.php).
    * fastcgi_pass wordpress:9000; → Sends PHP requests to the WordPress container (which runs on port 9000).
    * fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; → Ensures Nginx sends the correct PHP file location.

Summary (What This Config Does)
1. Redirects HTTP (80) → HTTPS (443) to force encryption.
2. Uses SSL certificates for security.
3. Serves WordPress from /var/www/html/.
4. Handles PHP requests and sends them to FastCGI (WordPress container).

#### Wordpress container

WordPress is an open-source content management system (CMS) designed for creating, managing, and publishing digital content.

##### Dockerfile

* Installing PHP and Extensions
```
RUN apk update && apk add mariadb-client \
    php83 \
    php83-fpm \
    php83-phar \
    php83-curl \
    php83-mysqli \
    php83-iconv \
    php83-json \
    wget 
```
    * Adds PHP 8.3 and multiple PHP extensions needed for WordPress:
    * php83-fpm → PHP FastCGI Process Manager (used by Nginx to process PHP).
    * php83-mysqli → Enables PHP to connect to MariaDB.
    * php83-curl, php83-json, etc. → Required for WordPress functionality.
    * Includes mariadb-client (instead of mariadb itself) since this container only connects to the database (MariaDB runs in a separate container).

* Copying a Custom PHP-FPM Config
```
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf
```
    * Copies a custom PHP-FPM configuration (www.conf).
    * This likely sets up PHP-FPM to run under the correct user (www-data) and listen on port 9000.

* Creating Folders for WordPress
```
RUN mkdir -p /var/www/wp /var/www/html
```
    * Ensures WordPress has two folders:
    * /var/www/wp/ (Possibly for WordPress installation).
    * /var/www/html/ (Public web directory).

* Running WordPress Setup Script
```
COPY ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh
RUN chmod +x /usr/local/bin/wordpress-script.sh 
```
    * Copies wordpress-script.sh, which automates WordPress installation and setup.
    * Makes the script executable (chmod +x).

* Creating a www-data User
```
RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data
```
    * Creates a system user (www-data) for PHP to run under.
    * This improves security by preventing PHP from running as root.

* Exposing Port 9000 for PHP-FPM
```
EXPOSE 9000
```
    * Tells Docker that this container listens on port 9000, so Nginx can connect to it for processing PHP files.

* Setting the Entry Command
```
CMD ["wordpress-script.sh"]
```
    * Runs the WordPress setup script when the container starts.
    * This script:
    - Downloads and installs WordPress.
    - Configures the database connection.
    - Starts PHP-FPM (to process PHP files).

Summary (Key Changes Compared to Before)
1. Installs PHP 8.3 & extensions needed for WordPress.
2. Uses mariadb-client instead of mariadb (this container doesn’t run the database).
3. Copies a PHP-FPM config (www.conf) for proper FastCGI setup.
4. Creates directories for WordPress files (/var/www/wp and /var/www/html).
5. Runs a WordPress setup script on startup (wordpress-script.sh).
6. Listens on port 9000 so Nginx can send PHP requests.

##### Config file

This is a PHP-FPM (www.conf) configuration file, which controls how PHP-FPM (FastCGI Process Manager) handles PHP requests.

* listen = 9000 → Defines Where PHP-FPM Listens:
    * PHP-FPM listens on port 9000, allowing Nginx to send PHP requests to this port.
    * This is why Nginx has: fastcgi_pass wordpress:9000; → It tells Nginx to send .php requests to the WordPress container on port 9000.

* pm = dynamic → Controls Process Management:
    * PHP-FPM dynamically adjusts the number of worker processes based on load.
    * Alternatives:
    - pm = static → Fixed number of processes.
    - pm = ondemand → Only creates processes when needed.

* Process Limits (pm.max_children, pm.start_servers, etc.)
    * These settings control how many PHP processes run at a time:
```
pm.max_children = 10
```
    * Maximum number of PHP-FPM worker processes (10 PHP requests can be processed simultaneously).
    * If all workers are busy, new requests wait.
```
pm.start_servers = 2
```
    * Starts 2 PHP worker processes when PHP-FPM launches.
```
pm.min_spare_servers = 1
pm.max_spare_servers = 3
```
    * Keeps between 1 and 3 idle workers ready for new requests.
    * Prevents unnecessary process creation/destruction, improving performance.

Summary (New Key Points)
1. PHP-FPM listens on port 9000, allowing Nginx to forward PHP requests.
2. Uses pm = dynamic to adjust PHP processes based on traffic.
3. Limits PHP processes (max_children = 10, start_servers = 2, etc.) to control resource usage.

##### Tools

This is a WordPress setup script that installs and configures WordPress inside a container. Let's go over the parts that we haven’t explained before.

* memory_limit = 512M → Increases PHP Memory Limit:
    * This increases PHP’s memory limit to 512MB, allowing WordPress to handle larger operations.
    * Helps prevent memory errors for big plugins or imports.

* WP-CLI (Command Line Tool for WordPress)
```
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
chmod +x /usr/local/bin/wp
```
    * Downloads WP-CLI, a command-line tool for managing WordPress.
    * Makes it executable so it can be used in scripts.

* mariadb-admin ping → Waits for Database to be Ready
```
mariadb-admin ping --protocol=tcp --host=mariadb -u $WORDPRESS_DATABASE_USER --password=$WORDPRESS_DATABASE_USER_PASSWORD --wait=300
```
    * Checks if MariaDB is running before proceeding.
    * The script waits up to 5 minutes (300s) if MariaDB isn’t ready yet.
    * Prevents WordPress setup from failing due to a missing database connection.

* wp core download → Downloads WordPress Core Files:
    * Downloads WordPress files (like index.php, wp-config-sample.php, etc.).
    * Uses --allow-root because the script runs as root inside the container.

* wp config create → Creates wp-config.php:
    * Generates the wp-config.php file, which contains database settings.
    * Uses environment variables ($WORDPRESS_DATABASE_NAME, etc.).
    * --force overwrites the file if it already exists.

* wp core install → Installs WordPress:
    * Sets up WordPress with a site title, admin user, and admin email.
    * --skip-email avoids sending confirmation emails.
    * --path=/var/www/html ensures WordPress installs in the correct directory.

* wp user create → Creates a New WordPress User
    * Creates a non-admin WordPress user.
    * Uses environment variables for credentials.

* php-fpm83 -F → Runs PHP-FPM in Foreground
    * Starts the PHP FastCGI Process Manager (PHP-FPM).
    * -F runs it in the foreground, preventing the container from stopping.

Summary (New Key Points)
1. Increases PHP memory limit to 512MB.
2. Uses WP-CLI to install and configure WordPress from the command line.
3. Waits for MariaDB to be ready before continuing.
4. Downloads WordPress, creates wp-config.php, installs WordPress, and creates users.
5. Runs PHP-FPM in foreground to keep the container alive.

### Starting a project

* install make: sudo apk add make
* do: make
* Allow all exposed ports for each service: sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
* To make it able to search by tmenkovi.42.fr change the dns by running: "sudo echo "127.0.0.1   tmenkovi.42.fr" >> /etc/hosts", but before runing it you need to change "su -"
* go back to inception: cd /home/tmenkovi/inception
* install firefox: sudo apk update && sudo apk add firefox
* open firefox in VM and type: https://tmenkovi.42.fr

### Commands during evaluation:

#### General:

* Transfer files from local to remote host:
```
scp -P 4241 -r /home/tmenkovi/inception_eval tmenkovi@localhost:~/
```

* View the whole Inception installation and configuration process with messages:
```
cd srcs
docker-compose up --build
```

* See running containers:
```
docker ps
```

* See logs for a specific container (example for mariadb):
```
docker logs mariadb
```

OR
```
cd ./srcs | docker-compose logs mariadb
```

* To inspect the network:
```
docker network inspect docker-network
```

* Verify correct usage of Docker daemon:
```
docker exec -it container-name ps aux #PID 1 cannot be any of these: bash, sh, sleep 
```

* Check Docker volume info:
```
docker volume ls 
docker volume inspect volume-name
```

#### Mariadb:

* Access MariaDB container's shell:
```
docker exec -it mariadb sh
```

* Enter mariaDB client inside the container:
```
mysql -u root -p
```
After this type password for mysql.

* Check what databases exist:
```
SHOW DATABASES;
```

* Check if mysql user exists (.env) and the priviledges granted to it:
```
SELECT User, Host FROM mysql.user;

SHOW GRANTS FOR tanjaaa;
```

* Check that WordPress tables are set up:
```
USE wordpress_db;
SHOW TABLES;
```

* Verify WordPress content (examples):
```
SELECT * FROM wp_users;
```

#### Wordpress:

* check if php-fpm is running inside the container
```
docker exec -it wordpress ps aux | grep php-fpm
```

* check if you can connect to MariaDB from WordPress
```
docker exec -it wordpress sh
mysql -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
```
OR
```
mysql -h mariadb -u emansoor -p
```

#### Nginx:

*check the validity of the SSL certificate:
```
docker exec -it container_id_or_name sh
openssl s_client -connect user.42.fr:443
```

* check if Nginx is actually listening to port 443 inside the container:
```
docker exec -it container-name netstat -tlnp
```

* test the same thing on host:
```
docker inspect container-name | grep "443" # if "HostPort": "443" is missing, game over
```
* check the TLS and http/https access inside the container:
```
docker exec -it container-name-or-id 
curl -k http://user.42.fr # should fail 
curl -k https://user.42.fr # should display a html document
curl -v https://user.42.fr # display TLS info
```