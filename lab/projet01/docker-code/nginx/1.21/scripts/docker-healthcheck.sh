#!/bin/bash


# *****************************************************************************
# ********************** check if nginx is alive ******************************
# *****************************************************************************

verif1=`nginx -v | grep ' nginx'`

if [ -z "$verif1" ] ; then
     echo $DATECREATION ": exit 0" >> /opt/nginx/logs/healthcheck.log             
     exit 0
else
     echo $DATECREATION ": exit 1" >> /opt/nginx/logs/healthcheck.log             
     exit 1
fi

