# Build stage for theme
FROM node:18-alpine AS theme-builder

WORKDIR /build

# Copy theme files
COPY ghost-theme/package*.json ./
RUN npm ci --production

COPY ghost-theme/ ./

# Build theme assets
RUN npm run build

# Ghost runtime stage
FROM ghost:6.0.0-rc.0

# Copy built theme
COPY --from=theme-builder /build /tmp/theme-built

# Copy custom entrypoint
COPY ghost-entrypoint.sh /usr/local/bin/ghost-entrypoint.sh
RUN chmod +x /usr/local/bin/ghost-entrypoint.sh

# Copy redirects file if it exists
COPY redirects.yaml* /tmp/

ENTRYPOINT ["/usr/local/bin/ghost-entrypoint.sh"]
CMD ["node", "current/index.js"]