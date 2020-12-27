# syntax = docker/dockerfile:experimental
FROM ubuntu:latest
LABEL maintainer="ddkd"
ARG USERNAME='app'
ARG DIR='/app'
ARG SUDO='true'
RUN mkdir /data
VOLUME /data
ENV PATH="$PATH:$DIR/bin:$DIR/.local/bin"
COPY /system /scripts/system
RUN --mount=type=secret,id=build-secrets,dst=/run/build-secrets.env \
    sh /scripts/system/set-root-password.sh \
    && DIR=$DIR USERNAME=$USERNAME SUDO=$SUDO sh /scripts/system/ubuntu/create-user.sh \
    && mkdir -p $DIR && chown $USERNAME:$USERNAME $DIR
USER $USERNAME
WORKDIR $DIR
CMD [ "bash" ]
