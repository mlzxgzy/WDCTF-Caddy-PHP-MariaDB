FROM caddy:latest

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
  && apk add curl php7-fpm php7-mysqli mariadb mariadb-client \
  && rm -rf /var/cache/apk/* \
  && sed -i "s/\/usr\/share\/caddy/\/srv/g" /etc/caddy/Caddyfile \
  && sed -i "s/# php_fastcgi localhost:9000/php_fastcgi localhost:9000/g" /etc/caddy/Caddyfile \
  && echo "/n2r.sh" > /init.sh \
  && echo "php-fpm7 -F &" >> /init.sh \
  && echo "/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &" >> /init.sh \
  && echo "mysqladmin ping -w=5" >> /init.sh \
  && echo "mysql < /init.sql" >> /init.sh \
  && echo "caddy run --config /etc/caddy/Caddyfile --adapter caddyfile" >> /init.sh \
  && echo "" > /n2r.sh \
  && chmod +x /n2r.sh \
  && chmod +x /init.sh \
  && mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

RUN echo 'if [ ! $MYSQL_USER ];then export MYSQL_USER="caddy";fi;' >> /n2r.sh \
  && echo 'if [ ! $MYSQL_PASS ];then export MYSQL_PASS="caddy";fi;' >> /n2r.sh \
  && echo 'if [ ! $MYSQL_HOST ];then export MYSQL_HOST="localhost";fi;' >> /n2r.sh \
  && echo 'if [ ! $MYSQL_DATABASE ];then export MYSQL_DATABASE="caddy";fi;' >> /n2r.sh \
  && echo 'echo "MySQL Information:";' >> /n2r.sh \
  && echo 'echo "    Username: $MYSQL_USER";' >> /n2r.sh \
  && echo 'echo "    Password: $MYSQL_PASS";' >> /n2r.sh \
  && echo 'echo "    Host: $MYSQL_HOST";' >> /n2r.sh \
  && echo 'echo "    Database: $MYSQL_DATABASE";' >> /n2r.sh \
  && echo 'sed -i "s/{user}/$MYSQL_USER/g" /init.sql;' >> /n2r.sh \
  && echo 'sed -i "s/{pass}/$MYSQL_PASS/g" /init.sql;' >> /n2r.sh \
  && echo 'sed -i "s/{host}/$MYSQL_HOST/g" /init.sql;' >> /n2r.sh \
  && echo 'sed -i "s/{data}/$MYSQL_DATABASE/g" /init.sql;' >> /n2r.sh


RUN echo 'CREATE USER "{user}"@"{host}" IDENTIFIED BY "{pass}";' >> /init.sql \
  && echo 'GRANT ALL ON *.* TO "{user}"@"{host}" IDENTIFIED BY "{pass}";' >> /init.sql \
  && echo 'CREATE DATABASE {data};' >> /init.sql \
  && echo 'FLUSH PRIVILEGES;' >> /init.sql

CMD "/init.sh"
