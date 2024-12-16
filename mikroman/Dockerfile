
FROM python:3.11-slim-bullseye

WORKDIR /app

RUN apt-get update  
RUN apt-get -y install cron
RUN apt-get install -y iputils-ping
RUN apt-get install -y net-tools
RUN apt-get install -y git

RUN touch /var/log/cron.log
RUN  git clone https://github.com/MikroWizard/mikroman.git /app

RUN set -ex \
    && buildDeps=' \
        build-essential \
        gcc \
    ' \
    && deps=' \
        htop \
    ' \
    && apt-get install -y $buildDeps git $deps --no-install-recommends  && rm -rf /var/lib/apt/lists/* \
    && pip install uWSGI==2.0.22 \
    && pip install -r /app/reqs.txt 


RUN mkdir -p /conf
RUN cp /app/conf/loginscript.sh /etc/profile
COPY server-conf.json /conf/
ARG AM_I_IN_A_DOCKER_CONTAINER=Yes
COPY init.sh /app/ 
COPY initpy.py /app/ 
COPY testdb.py /app/ 

RUN chmod +x /app/init.sh 

# background spooler dir
RUN mkdir /tmp/pysrv_spooler

# we don't need this file with Docker but uwsgi looks for it
RUN echo `date +%s` >/app/VERSION

EXPOSE 80


# our server config file
# - you should write your own config file and put OUTSIDE the repository
#   since the config file contains secrets
# - here I use the sample template from repo
# - it is also possible to override the config with env variables, either here
#   or in Amazon ECS or Kubernetes configuration
#COPY /app/real-server-config.json /app/real-server-config.json
# ENV PYSRV_DATABASE_HOST host.docker.internal
# ENV PYSRV_REDIS_HOST host.docker.internal
# ENV PYSRV_DATABASE_PASSWORD x

# build either a production or dev image

ARG BUILDMODE=production
ENV ENVBUILDMODE=$BUILDMODE

RUN echo "BUILDMODE $ENVBUILDMODE"

# run in shell mode with ENV expansion
RUN cd /app && bash init.sh


