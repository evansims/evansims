FROM alpine:latest

# Install useful administrative tools
RUN apk add --no-cache \
    bash \
    curl \
    mysql-client \
    postgresql-client \
    redis \
    jq \
    wget \
    vim \
    nano \
    htop \
    netcat-openbsd \
    openssl \
    ca-certificates \
    tzdata \
    git

# Create a nice prompt
RUN echo 'export PS1="\[\033[1;36m\]admin@evansims\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]# "' >> /root/.bashrc

# Create helpful aliases
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias mysql-ghost="mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD ghost"' >> /root/.bashrc && \
    echo 'alias mysql-activitypub="mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub"' >> /root/.bashrc && \
    echo 'alias mysql-root="mysql -h db -u root -p$MYSQL_ROOT_PASSWORD"' >> /root/.bashrc

WORKDIR /root

# Keep container running
CMD ["tail", "-f", "/dev/null"]