#Only supports Ubuntu 16.04

#!/bin/bash

#Checking to see if user is running as root
if [[ $EUID -ne 0 ]]; then
   echo "You need to be root to run this script."
   exit 1
fi


apt-get install libcairo2-dev libjpeg62-dev libpng12-dev libossp-uuid-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libssh-dev tomcat7 tomcat7-admin tomcat7-user

wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.9.tar.gz

tar zxf guacamole-server-0.9.9.tar.gz

guacamole-server-0.9.9/configure

guacamole-server-0.9.9/make

guacamole-server-0.9.9/make install

wget http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-0.9.9.war /var/lib/tomcat7

mv guacamole-0.9.9.war /var/lib/tomcat7/webapps/guacamole.war

mkdir /usr/share/tomcat7/.guacamole

touch /etc/guacamole/guacamole.properties

echo 'guacd-hostname: localhost' | tee /etc/guacamole/guacamole.properties

echo 'gucad-port: 4822' | tee /etc/guacamole/guacamole.properties

echo 'user-mapping: /etc/guacamole/user-mapping.xml' | tee /etc/guacamole/guacamole.properties

echo 'auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthentiionProvider' | tee /etc/guacamole/guacamole.properties

echo 'basic-user-mapping: /etc/guacamole/user-mapping.xml' | tee /etc/guacamole/guacamole.properties


ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat7/.guacamole/

touch /etc/guacamole/user-mapping.xml

service tomcat7 start

/usr/local/sbin/guacd &

