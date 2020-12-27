# syntax = docker/dockerfile:experimental
FROM alpine:latest
LABEL maintainer="ddkd"
ARG USERNAME='app'
ARG DIR='/app'
ARG SUDO='true'
RUN mkdir /data
VOLUME /data
COPY /system /scripts/system
RUN --mount=type=secret,id=build-secrets,dst=/run/build-secrets.env \
    sh /scripts/system/set-root-password.sh \
    && DIR=$DIR USERNAME=$USERNAME SUDO=$SUDO sh /scripts/system/alpine/create-user.sh \
    && mkdir -p $DIR && chown $USERNAME:$USERNAME $DIR
RUN sh /scripts/system/alpine/install-cli-tools.sh
# RUN sh /scripts/system/alpine/install-bash.sh
ENV PATH="$PATH:$DIR/bin"
USER $USERNAME
WORKDIR $DIR
CMD [ "sh" ]
