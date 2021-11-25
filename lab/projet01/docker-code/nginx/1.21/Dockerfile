##
## nginx 1.21 : image creation
##
FROM debian:11.1
MAINTAINER "your name" 

# Set up directory requirements
#VOLUME ["/opt/projet01/data-shared"]
RUN mkdir -p /opt/projet01/data-shared

RUN mkdir -p /opt/nginx/software
RUN mkdir -p /opt/nginx/scripts
RUN mkdir -p /opt/nginx/logs
RUN mkdir -p /opt/nginx/config
RUN mkdir -p /opt/nginx/data-nginx
RUN mkdir -p /opt/nginx/letsencrypt-with-cerbot
RUN mkdir -p /var/www/html/data-pictures
RUN mkdir -p /var/log/nginx
RUN mkdir -p /etc/letsencrypt
RUN mkdir -p /var/www/cerbot
RUN mkdir -p /var/lib/nginx/body

# copy scripts
COPY scripts/docker-entrypoint.sh /opt/nginx/scripts
COPY scripts/docker-create-user.sh /opt/nginx/scripts
COPY scripts/docker-healthcheck.sh /opt/nginx/scripts
COPY scripts/docker-install-software.sh /opt/nginx/scripts

RUN chmod 755 -R /opt/nginx

# copy nginx packages
COPY software /opt/nginx/software
COPY config /opt/nginx/config

# Create admin user
ARG USER_UID
ARG GROUP_GID
ARG UNAME

ENV USER_UID=$USER_UID
ENV GROUP_GID=$GROUP_GID
ENV UNAME=$UNAME
ENV LOGPATH="/opt/nginx/logs"
ENV LOGUSER="docker-create_user.log"
ENV LOGENTRY="docker-entrypoint.log"
ENV LOGERROR="docker-entrypoint_error.log"
ENV NGINX_SETUP=$NGINX_SETUP
ENV NGINX_WEBSITE=$NGINX_WEBSITE
ENV DOCKER_DEBUG_FLAG=$DOCKER_DEBUG_FLAG

ENV PATH $PATH:/opt/nginx:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN chown -R $USER_UID:$GROUP_GID /opt/nginx
RUN chmod 755 -R /opt/nginx
RUN sh /opt/nginx/scripts/docker-create-user.sh
RUN sh /opt/nginx/scripts/docker-install-software.sh


# change owner /opt/projet01
RUN chown -R $USER_UID:$GROUP_GID /opt/projet01
RUN chmod -R 755 /opt/projet01

# change owner /opt/projet01
RUN chown -R $USER_UID:$GROUP_GID /opt/nginx
RUN chown -R $USER_UID:$GROUP_GID /var/lib/nginx
RUN chown -R $USER_UID:$GROUP_GID /var/log/nginx
RUN chmod -R 755 /var/log/nginx
RUN chmod -R 755 /var/lib/nginx
RUN chmod -R 755 /opt/nginx


USER $USER_UID:$GROUP_GID


# Set nginx environment
#ENV HOME /opt/nginx
WORKDIR /opt/nginx

# Start bootstrap script
ENTRYPOINT ["/opt/nginx/scripts/docker-entrypoint.sh"]
#CMD ["bash"]

 
