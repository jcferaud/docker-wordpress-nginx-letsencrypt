#!/bin/bash

# creation of LOGFILE
export PODNAME=`hostname`
export DATECREATION=`date +"%d-%h-%y:%T"`
export LOGFILE="$LOGPATH/${PODNAME}-${LOGENTRY}"
export ERRFILE="$LOGPATH/${PODNAME}-${LOGERROR}"
echo "LOGFILE: $LOGFILE"
echo "\n**********************************************************\n" >> $LOGFILE
echo ${DATECREATION} >> $LOGFILE
echo  "\n**********************************************************\n" >> $LOGFILE
echo "NGINX_SETUP: $NGINX_SETUP" >> $LOGFILE
echo "NGINX_WEBSITE: $NGINX_WEBSITE" >> $LOGFILE
echo "DOCKER_DEBUG_FLAG: $DOCKER_DEBUG_FLAG" >> $LOGFILE
echo $USER_UID:$GROUP_GID >> $LOGFILE
echo $UNAME >> $LOGFILE

# change rights
sudo chmod 755 -R /etc/nginx
sudo chown $USER_UID:$GROUP_GID -R /etc/nginx

sudo touch /run/nginx.pid
sudo chmod 777 /run/nginx.pid
sudo chown $USER_UID:$GROUP_GID /run/nginx.pid

sudo touch /var/log/nginx/access.log
sudo chmod 777 /var/log/nginx/access.log
sudo chown $USER_UID:$GROUP_GID /var/log/nginx/access.log

sudo touch /var/log/nginx/error.log
sudo chmod 777 /var/log/nginx/error.log
sudo chown $USER_UID:$GROUP_GID /var/log/nginx/error.log

sudo chmod 755 -R /var/www/html
sudo chown $USER_UID:$GROUP_GID -R /var/www/html


# creation of an index.html file for testing purposes
cp /opt/nginx/config/website-index.html /var/www/html/index.html
export text1="XXX"
export text2=${NGINX_WEBSITE}
export var="sed -i 's/${text1}/${text2}/g' /var/www/html/index.html"
sed -i "s/${text1}/${text2}/g" /var/www/html/index.html


# setup nginx  
if [ ${NGINX_SETUP} = 'http' ] ; then
   cp /opt/nginx/config/website-sites-available.domain /etc/nginx/sites-available/myblog.fr
   sed -i "s/${text1}/${text2}/g" /etc/nginx/sites-available/myblog.fr
   mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
   cp /opt/nginx/config/website-nginx-http.conf /etc/nginx/nginx.conf
   sed -i "s/${text1}/${text2}/g" /etc/nginx/nginx.conf
fi

if [ ${NGINX_SETUP} = 'https' ] ; then
   cp /opt/nginx/config/website-sites-available.domain /etc/nginx/sites-available/myblog.fr
   sed -i "s/${text1}/${text2}/g" /etc/nginx/sites-available/myblog.fr
   mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
   cp /opt/nginx/config/website-nginx-https.conf /etc/nginx/nginx.conf
   sed -i "s/${text1}/${text2}/g" /etc/nginx/nginx.conf
fi

if [ ${NGINX_SETUP} = 'proxypass' ] ; then
   cp /opt/nginx/config/website-sites-available.domain /etc/nginx/sites-available/myblog.fr
   sed -i "s/${text1}/${text2}/g" /etc/nginx/sites-available/myblog.fr
   mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
   cp /opt/nginx/config/website-nginx-https-proxypass-wordpress.conf /etc/nginx/nginx.conf
   sed -i "s/${text1}/${text2}/g" /etc/nginx/nginx.conf
   sudo tar -zxvf /opt/nginx/config/letsencrypt-with-certbot-myblog-fr.tar.gz -C /etc
   sudo chmod 755 -R /etc/letsencrypt/live
   sudo chmod 755 -R /etc/letsencrypt/livearchive/myblog.fr/*
   sudo chown -R $USER_UID:$GROUP_GID /etc/letsencrypt/archive
fi

# start nginx
var="/usr/sbin/nginx"
echo "var: $var" >> $LOGFILE
eval $var

# End
export DATEFIN=`date +"%d-%h-%y:%T"`
echo ${DATEFIN} >> $LOGFILE
echo "docker-entrypoint.sh: End" >> $LOGFILE
echo "**********************************************************" >> $LOGFILE

# check if the debugging option is setup to exit
# lancement de bash
var="/bin/bash"
if [ ${DOCKER_DEBUG_FLAG} != 'exit' ] ; then
   eval $var
fi
