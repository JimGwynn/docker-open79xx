FROM linuxconfig/nginx
MAINTAINER bakStaaJ <docker@bakStaaJ.com>

VOLUME /var/lib/mysql

ENV DEBIAN_FRONTEND noninteractive

# Main package installation
RUN apt-get update
RUN apt-get -y install supervisor php-cgi mysql-server php-mysql 

# Extra package installation
RUN apt-get -y install php-gd php-apcu php-mcrypt php-cli php-fpm php-curl php-pear

# Nginx configuration
COPY ./files/default /etc/nginx/sites-available/
COPY ./files/nginx.conf /etc/nginx/
# PHP FastCGI script
COPY ./files/php.ini /etc/php/7.0/cli
COPY ./files/php-fcgi /usr/local/sbin/
RUN chmod o+x /usr/local/sbin/php-fcgi
RUN chmod 777 /run
RUN chmod 777 /tmp

# Supervisor configuration files
COPY ./files/supervisord.conf /etc/supervisor/
COPY ./files/supervisor-lemp.conf /etc/supervisor/conf.d/

# open79xx website
COPY ./files/index.php /var/www/html/
COPY ./files/install.php /var/www/html/
COPY ./files/db.sql /var/www/html/
COPY ./files/WebUI /var/www/html/WebUI
COPY ./files/PhoneUI /var/www/html/PhoneUI
COPY ./files/lib /var/www/html/lib


# Create new MySQL admin user
RUN service mysql start;mysql -u root -e "CREATE DATABASE asterisk;";mysql -u root asterisk < /var/www/html/db.sql;mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'core';";mysql -u root -e "GRANT ALL PRIVILEGES ON asterisk.* TO 'admin'@'%' WITH GRANT OPTION;";

# MySQL configuration
RUN sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

# Clean up
RUN apt-get clean

EXPOSE 80 3306

CMD ["supervisord"]
