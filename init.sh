if [ ! $MYSQL_USER ]
then
  export MYSQL_USER="caddy";
fi
if [ ! $MYSQL_PASS ]
then
  export MYSQL_PASS="caddy";
fi
if [ ! $MYSQL_HOST ]
then
  export MYSQL_HOST="localhost";
fi
if [ ! $MYSQL_DATABASE ]
then
  export MYSQL_DATABASE="caddy";
fi

echo "MySQL Information:";
echo "    Username: $MYSQL_USER";
echo "    Password: $MYSQL_PASS";
echo "    Host: $MYSQL_HOST";
echo "    Database: $MYSQL_DATABASE";

sed -i "s/{user}/$MYSQL_USER/g" /init.sql
sed -i "s/{pass}/$MYSQL_PASS/g" /init.sql
sed -i "s/{host}/$MYSQL_HOST/g" /init.sql
sed -i "s/{data}/$MYSQL_DATABASE/g" /init.sql

php-fpm7 -F &
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
mysqladmin ping -w=5
mysql < /init.sql
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
