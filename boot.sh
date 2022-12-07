#!/bin/bash
  
# Start the first process
env > /etc/.cronenv

service cron start &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start cron: $status"
  exit $status
fi
mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.example

cat /etc/mysql/mysql.conf.d/mysqld.example | grep -v 'bind-address' > /etc/mysql/mysql.conf.d/mysqld.cnf
echo "bind-address            = 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "port                    = 3336" >>   /etc/mysql/mysql.conf.d/mysqld.cnf

mv /var/lib/mysql /var/lib/mysql-container
mv /var/lib/mysql-files /var/lib/mysql-files-container
ln -s /data/mysql/ /var/lib/mysql
ln -s /data/mysql-files /var/lib/mysql-files

service mysql start &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start mysql: $status"
  exit $status
fi

service proxysql start &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start mysql: $status"
  exit $status
fi

bash
