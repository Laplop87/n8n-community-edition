ARG N8N_VERSION=2.31.6

FROM n8nio/n8n:${N8N_VERSION}

USER root

# Install Python 3 and pip, then the email validation library
RUN apk add --no-cache python3 py3-pip \
    && pip3 install --break-system-packages email-validator \
    && rm -rf /var/cache/apk/*

# Switch back to the default n8n user
USER node