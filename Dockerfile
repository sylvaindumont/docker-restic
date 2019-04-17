FROM alpine:latest

ENV RESTIC_VERSION=latest

RUN set -ex \
    && apk add --no-cache --no-progress --virtual BUILD_DEPS \
           bzip2 \
           curl \
    && apk add --no-cache --no-progress \
           apache2-utils \
           ca-certificates \
\
    && export $(curl --location "https://github.com/timonier/version-lister/raw/generated/restic/restic/${RESTIC_VERSION}" | xargs) \
    && curl --location --output /tmp/restic.bz2 "https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2" \
    && bunzip2 /tmp/restic.bz2 \
    && mv /tmp/restic /usr/bin/restic \
    && chmod +x /usr/bin/restic \
\
    && curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip \
    && unzip rclone-current-linux-amd64.zip \
    && cd rclone-*-linux-amd64 \
    && mv rclone /usr/bin/ \
    && chmod +x /usr/bin/rclone \
\
    && apk del --no-progress \
           BUILD_DEPS \
    && rm -f -r \
           /tmp/*

ENTRYPOINT [ "/usr/bin/restic" ]
