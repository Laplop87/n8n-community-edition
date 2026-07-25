ARG N8N_VERSION=2.31.6
ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS apktools
RUN apk add --no-cache apk-tools-static

FROM n8nio/n8n:${N8N_VERSION}
ARG ALPINE_VERSION
USER root

# Copy the static apk binary (fully self-contained)
COPY --from=apktools /sbin/apk.static /sbin/apk.static
COPY --from=apktools /etc/apk/keys /tmp/apk-keys

# Set up repository keys and use apk.static to install Python packages
RUN mkdir -p /etc/apk /etc/apk/keys \
    && cp -n /tmp/apk-keys/* /etc/apk/keys/ || true \
    && printf 'https://dl-cdn.alpinelinux.org/alpine/v%s/main\nhttps://dl-cdn.alpinelinux.org/alpine/v%s/community\n' "$ALPINE_VERSION" "$ALPINE_VERSION" > /etc/apk/repositories \
    && /sbin/apk.static -X "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main" -U add python3 py3-pip \
    && rm -f /sbin/apk.static \
    && rm -rf /tmp/apk-keys

# Install the email-validator Python package
RUN pip3 install --break-system-packages email-validator \
    && rm -rf /var/cache/apk/*

USER node