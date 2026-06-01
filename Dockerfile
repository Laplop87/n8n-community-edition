ARG N8N_VERSION=2.22.6
ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS apktools
RUN apk add --no-cache apk-tools-static

FROM n8nio/n8n:${N8N_VERSION}
ARG ALPINE_VERSION
USER root

# Restore apk-tools (removed since n8n v2.1.0)
COPY --from=apktools /sbin/apk.static /sbin/apk.static
COPY --from=apktools /etc/apk/keys /tmp/apk-keys
RUN mkdir -p /etc/apk /etc/apk/keys \
    && cp -n /tmp/apk-keys/* /etc/apk/keys/ || true \
    && printf 'https://dl-cdn.alpinelinux.org/alpine/v%s/main\nhttps://dl-cdn.alpinelinux.org/alpine/v%s/community\n' "$ALPINE_VERSION" "$ALPINE_VERSION" > /etc/apk/repositories \
    && /sbin/apk.static -X "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main" -U add apk-tools \
    && rm -f /sbin/apk.static \
    && rm -rf /tmp/apk-keys

# Install Python 3 and pip, then the email validation library
RUN apk add --no-cache python3 py3-pip \
    && pip3 install --break-system-packages email-validator \
    && rm -rf /var/cache/apk/*

# Switch back to the default n8n user
USER node
