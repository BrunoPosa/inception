#!/bin/sh

echo "--> Setting up MariaDB..."
START=$(date +%s)

chmod -R 755 /var/lib/mysql
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
        mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null
        mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

ALTER user 'root'@'localhost' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD";
CREATE DATABASE $WORDPRESS_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$WORDPRESS_DATABASE_USER'@'%' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO '$WORDPRESS_DATABASE_USER'@'%';
CREATE USER '$WORDPRESS_DATABASE_USER'@'localhost' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO '$WORDPRESS_DATABASE_USER'@'localhost';
FLUSH PRIVILEGES;
EOF
else
        echo "MariaDB already installed."
fi

echo "Starting MariaDB..."
exec mysqld --defaults-file=/etc/my.cnf.d/mariadb_config 2>&1

END=$(date +%s)
echo "MariaDB initialized in $((END - START)) seconds"