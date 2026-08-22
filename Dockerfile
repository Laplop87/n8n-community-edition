ARG N8N_VERSION=2.35.7

FROM n8nio/n8n:${N8N_VERSION}

USER root

# Install Python 3 and pip, then the email validation library
RUN apk add --no-cache python3 py3-pip \
    && pip3 install --break-system-packages email-validator \
    && rm -rf /var/cache/apk/*

# Set the default theme to Light
ENV N8N_DEFAULT_THEME=light

# Switch back to the default n8n user
<<<<<<< HEAD
USER node
=======
USER node
>>>>>>> 37d96fc (Fix Dockerfile content for n8n 2.35.7)
