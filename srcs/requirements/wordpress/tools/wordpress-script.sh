#!/bin/sh

#color
yellow() { echo -e "\033[1;33m$1\033[0m"; }

yellow "--> Setting up WordPress..."

echo "memory_limit = 512M" >> /etc/php83/php.ini

cd /var/www/html

wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
chmod +x /usr/local/bin/wp

MAX_RETRIES=500
i=0
until mariadb-admin ping --protocol=tcp --host=mariadb -u "$WORDPRESS_DATABASE_USER" --password="$WORDPR
    i=$((i+1))
    if [ "$i" -ge "$MAX_RETRIES" ]; then
        echo "MariaDB did not become available in time."
        exit 1
    fi
    echo "Waiting for MariaDB... ($i/$MAX_RETRIES)"
    sleep 1
done

if [ ! -f /var/www/html/wp-config.php ]; then
        wp core download --allow-root

        wp config create \
        --dbname=$WORDPRESS_DATABASE_NAME \
        --dbuser=$WORDPRESS_DATABASE_USER \
        --dbpass=$WORDPRESS_DATABASE_USER_PASSWORD \
        --dbhost=mariadb \
        --force

        wp core install --url="$DOMAIN_NAME" --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root \
        --skip-email \
        --path=/var/www/html


        wp user create \
        --allow-root \
        $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
        --user_pass=$WORDPRESS_USER_PASSWORD
else
        echo "WordPress is already installed."
fi

chown -R www-data:www-data /var/www/html

chmod -R 755 /var/www/html/

echo "Starting PHP-FPM in the foreground..."
php-fpm83 -F
