#!/usr/bin/env bash

#Update YUM
yum -y update

#Screen
yum -y install screen

#Apache
yum install httpd -y
service httpd start
chkconfig httpd on
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
service iptables restart

#MySQL
yum install mysql mysql-server -y
service mysqld start
chkconfig mysqld on

#PHP
yum install php php-mysql -y

#Change web root to shared vagrant directory
# if ! [ -L /var/www ]; then
#    rm -rf /var/www
#    ln -fs /vagrant /var/www
# fi

# apt-get install -y apache2
# sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-cli
# sudo apt-get install -y mysql-server php5-mysql
# mysql_install_db
# mysql_secure_installation