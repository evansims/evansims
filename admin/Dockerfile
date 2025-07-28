FROM ubuntu:22.04

# Set non-interactive to avoid tzdata prompt
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Pre-configure tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install MySQL client and other useful administrative tools
RUN apt-get update && apt-get install -y \
    mysql-client \
    bash \
    curl \
    postgresql-client \
    redis-tools \
    jq \
    wget \
    vim \
    nano \
    htop \
    netcat-openbsd \
    openssl \
    ca-certificates \
    tzdata \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install golang-migrate for database migrations
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.0/migrate.linux-amd64.tar.gz | tar xvz && \
    mv migrate /usr/local/bin/ && \
    chmod +x /usr/local/bin/migrate

# Create a nice prompt
RUN echo 'export PS1="\[\033[1;36m\]admin@evansims\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]# "' >> /root/.bashrc

# Create helpful aliases
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias mysql-ghost="mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD ghost"' >> /root/.bashrc && \
    echo 'alias mysql-activitypub="mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub"' >> /root/.bashrc && \
    echo 'alias mysql-root="mysql -h db -u root -p$MYSQL_ROOT_PASSWORD"' >> /root/.bashrc && \
    echo 'alias run-activitypub-migrations="/scripts/run-activitypub-migrations.sh"' >> /root/.bashrc && \
    echo 'alias check-migration-status="/scripts/check-migration-status.sh"' >> /root/.bashrc

WORKDIR /root

# Keep container running
CMD ["tail", "-f", "/dev/null"]