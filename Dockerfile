FROM caddy:latest

COPY ./init.sh /init.sh

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
  && apk add curl php7-fpm php7-mysqli mariadb mariadb-client \
  && rm -rf /var/cache/apk/* \
  && sed -i "s/\/usr\/share\/caddy/\/srv/g" /etc/caddy/Caddyfile \
  && sed -i "s/# php_fastcgi localhost:9000/php_fastcgi localhost:9000/g" /etc/caddy/Caddyfile \
  && mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql \
  && chmod +x /init.sh

RUN echo 'CREATE USER "{user}"@"{host}" IDENTIFIED BY "{pass}";' >> /init.sql \
  && echo 'GRANT ALL ON *.* TO "{user}"@"{host}" IDENTIFIED BY "{pass}";' >> /init.sql \
  && echo 'CREATE DATABASE {data};' >> /init.sql \
  && echo 'FLUSH PRIVILEGES;' >> /init.sql

CMD "/init.sh"
