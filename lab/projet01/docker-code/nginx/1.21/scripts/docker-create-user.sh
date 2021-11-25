#!/bin/bash

export PODNAME=`hostname`
export DATECREATION=`date +"%d-%h-%y:%T"`
export LOGFILE="$LOGPATH/${PODNAME}-${LOGUSER}"


echo "*****************************************************" >> $LOGFILE
echo ${DATECREATION} >> $LOGFILE
echo $USER_UID:$GROUP_GID >> $LOGFILE
echo $UNAME >> $LOGFILE

test_docker_user_exists=`grep $USER_UID:$GROUP_GID /etc/passwd | cut -d: -f1`
if [ -z "$test_docker_user_exists" ]; then
  echo "test: user $USER_UID not exists !" >> $LOGFILE;
   if [ $GROUP_GID -lt 1000 ]; then groupadd -r -g $GROUP_GID $UNAME; fi
   if [ $GROUP_GID -gt 999 ]; then groupadd -g $GROUP_GID $UNAME; fi
   if [ $USER_UID -lt 1000 ]; then useradd -r -u $USER_UID -g $GROUP_GID -s /sbin/nologin $UNAME; fi
   if [ $USER_UID -gt 999 ]; then useradd -u $USER_UID -g $GROUP_GID -s /sbin/nologin $UNAME; fi
   else
   UNAME=$test_docker_user_exists
   echo "test: user $USER_UID exists !" >> $LOGFILE;
   echo "test: uname=$UNAME" >> $LOGFILE;
fi
chsh -s /bin/bash $UNAME
touch /etc/sudoers
chmod 755 /etc/sudoers
echo $UNAME" ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
chmod 440 /etc/sudoers
