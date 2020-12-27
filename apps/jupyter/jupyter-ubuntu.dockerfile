# syntax = docker/dockerfile:experimental
FROM ubuntu:latest
LABEL maintainer="ddkd"
ARG USERNAME='app'
ARG DIR='/app'
ARG SUDO='true'
RUN mkdir "/notebooks"
VOLUME "/notebooks"
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git curl
RUN curl -sL https://deb.nodesource.com/setup_12.x -o /tmp/install-node.sh \
    && sh /tmp/install-node.sh
COPY /system /scripts/system
RUN --mount=type=secret,id=build-secrets,dst=/run/build-secrets.env \
    sh /scripts/system/set-root-password.sh \
    && DIR=$DIR USERNAME=$USERNAME SUDO=$SUDO sh /scripts/system/ubuntu/create-user.sh \
    && mkdir -p $DIR && chown $USERNAME:$USERNAME $DIR \
    && chown -R $USERNAME:$USERNAME "/notebooks"
RUN sh /scripts/system/ubuntu/install-python.sh \
    && pip install jupyterlab jupyterlab-git
USER $USERNAME
WORKDIR $DIR
EXPOSE 8888
CMD [ "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--notebook-dir=/notebooks" ]
