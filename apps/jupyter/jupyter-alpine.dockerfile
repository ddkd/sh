# syntax = docker/dockerfile:experimental
# todo: resolve gcc errors on pip install jupyterlab

FROM alpine:latest
LABEL maintainer="ddkd"
ARG USERNAME='app'
ARG DIR='/app'
ARG SUDO='true'
RUN mkdir /notebooks
VOLUME /notebooks
ENV PATH="$PATH:$DIR/bin:$DIR/.local/bin"
COPY /system /scripts/system
RUN sh /scripts/system/alpine/use-community-repository.sh \
    && apk update \
    && apk upgrade
RUN sh /scripts/system/alpine/install-cli-tools.sh
RUN --mount=type=secret,id=build-secrets,dst=/run/build-secrets.env \
    sh /scripts/system/set-root-password.sh \
    && DIR=$DIR USERNAME=$USERNAME SUDO=$SUDO sh /scripts/system/alpine/create-user.sh \
    && mkdir -p $DIR && chown $USERNAME:$USERNAME $DIR \
    && chown -R $USERNAME:$USERNAME "/notebooks"
RUN apk update \
    && apk add \
        ca-certificates \
        libstdc++ \
    && apk add --virtual=build_dependencies \
        build-base \
        python3-dev \
        libffi-dev \
    && sh /scripts/system/alpine/install-python.sh
RUN pip install wheel \
    && pip install cython \
    && chown $USERNAME:$USERNAME /notebooks \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    && pip install jupyterlab
    && jupyter serverextension enable --py jupyterlab --sys-prefix
RUN apk del --purge -r build_dependencies \
    && rm -rf /var/cache/apk/*
USER $USERNAME
WORKDIR $DIR
ENV PYTHONUNBUFFERED=0
EXPOSE 8888
CMD [ "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--notebook-dir=/notebooks" ]
