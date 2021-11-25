#!/bin/bash

export PODNAME=`hostname`
export DATECREATION=`date +"%d-%h-%y:%T"`
export LOGFILE="$LOGPATH/${PODNAME}-${LOGENTRY}"
export ERRFILE="$LOGPATH/${PODNAME}-${LOGERROR}"


echo "nginx install : Start" >> $LOGFILE
echo "DATE: ${DATECREATION}" >> $LOGFILE

# prerequisite for offline installation
export DEBIAN_FRONTEND="noninteractive"
echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

apt-get update -y

# debian updates 
apt-get install -y iputils-ping
apt-get install -y procps
apt-get install -y sudo
apt-get install -y net-tools
apt-get install -y vim
apt-get install -y tini
apt-get install -y curl

# install nginx + cerbot
apt-get install -y curl gnupg2 ca-certificates lsb-release
apt-get install -y nginx
apt-get install certbot python3-certbot-nginx -y

# end of script
echo "nginx install : END" >> $LOGFILE

