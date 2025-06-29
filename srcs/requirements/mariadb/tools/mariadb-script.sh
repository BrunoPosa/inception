#!/usr/bin/env sh
set -eu

echo "--> Setting up MariaDB..."

MYSQL_ROOT_PASSWORD="$(cat /run/secrets/mysql_root_password)"
WORDPRESS_DATABASE_USER_PASSWORD="$(cat /run/secrets/wp-db-usr_password)"

: "${WORDPRESS_DATABASE_NAME:?Missing WORDPRESS_DATABASE_NAME}"
: "${WORDPRESS_DATABASE_USER:?Missing WORDPRESS_DATABASE_USER}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chmod 750 /var/lib/mysql

# Only init if empty
if [ -z "$(ls -A /var/lib/mysql)" ]; then
    echo "Initializing database..."
    mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null

    echo "Running bootstrap SQL..."
    mysqld --user=mysql --bootstrap <<EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DATABASE_NAME}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${WORDPRESS_DATABASE_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DATABASE_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WORDPRESS_DATABASE_NAME}\`.* TO '${WORDPRESS_DATABASE_USER}'@'%';
FLUSH PRIVILEGES;
EOF

else
    echo "MariaDB already initialized."
fi

echo "Starting MariaDB..."
exec mysqld --defaults-file=/etc/my.cnf.d/mariadb_config 2>&1
