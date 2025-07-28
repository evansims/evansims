# Deployment on Dokploy

## Required Environment Variables

Configure these in Dokploy's environment variables UI:

### Database Configuration
- `DATABASE_PASSWORD` - Password for Ghost database user (required)
- `MYSQL_ROOT_PASSWORD` - MySQL root password (required)

### Critical Configuration
- `GHOST_URL` - Must be set to your full URL including protocol (e.g., `https://evansims.com`)

### Optional Configuration

#### Ghost Settings
- `GHOST_URL` - Your blog URL (default: `https://evansims.com`)
- `NODE_ENV` - Environment mode (default: `production`)
- `ENABLE_ACTIVITYPUB` - Enable ActivityPub federation (default: `true`)

#### Database Settings (if using external database)
- `DATABASE_CLIENT` - Database type (default: `mysql`)
- `DATABASE_HOST` - Database hostname (default: `db`)
- `DATABASE_USER` - Database username (default: `ghost`)
- `DATABASE_NAME` - Database name (default: `ghost`)

#### Email Configuration
To enable email functionality, configure these variables:
- `MAIL_USER` - SMTP username
- `MAIL_PASSWORD` - SMTP password
- `MAIL_HOST` - SMTP server hostname
- `MAIL_PORT` - SMTP port (default: `587`)
- `MAIL_TRANSPORT` - Mail transport method (default: `SMTP`)

## Deployment Steps

1. Create a new project in Dokploy
2. Connect this repository
3. Set the required environment variables listed above
4. Deploy using the `docker-compose.yml` file
5. Configure Dokploy to route traffic to the `caddy` service on port 80
6. Your site will be available at your configured domain

## Service Architecture

This deployment uses Caddy as a reverse proxy to route requests:
- **Caddy** (internal port 80): Main entry point, handles all HTTP/2 traffic
  - Routes `/.ghost/activitypub/*` → ActivityPub service (port 8080)
  - Routes all other requests → Ghost (port 2368)
- **Ghost** (port 2368): Main blog application
- **ActivityPub** (port 8080): Federation service
- **MySQL** (port 3306): Shared database
- **Admin**: Administrative container with MySQL client and other tools

## Federation Support

### ActivityPub (Beta)

This configuration includes the TryGhost ActivityPub service, which runs alongside Ghost to enable federation. When enabled, your Ghost blog can:
- Be followed from Mastodon, Threads, and other ActivityPub-compatible platforms
- Automatically publish new posts to followers' feeds
- Enable readers to interact with your content from their preferred platform

The ActivityPub service:
- Runs on port 8080 (internally, accessed via Caddy proxy)
- Uses its own database (`activitypub`) with the same MySQL instance
- Uses the official pre-built image from GitHub Container Registry (ghcr.io/tryghost/activitypub:edge)
- Handles all federation protocols and interactions
- Accessed via `/.ghost/activitypub/*` paths

**Important Notes**:
- ActivityPub is currently in beta and may have limited functionality
- The "edge" tag provides the latest development version
- All traffic is routed through Caddy, which provides HTTP/2 support
- Federation endpoints are automatically proxied to the correct service

### Mastodon Redirects

This configuration also includes Ghost redirects for Mastodon federation endpoints from evansims.com to mastodon.evansims.com. The following paths are automatically redirected:

- `/.well-known/host-meta` - WebFinger discovery
- `/.well-known/webfinger` - Account lookups
- `/@evan` - Profile redirect
- `/users/evan` - ActivityPub actor

This allows users to find your Mastodon account using @evan@evansims.com instead of @evan@mastodon.evansims.com.

**Note**: Dokploy should be configured to route traffic from port 80/443 to this container's port 2368.

## First-Time Setup

After deployment, visit `https://evansims.com/ghost` to complete the Ghost setup wizard and create your admin account.

## Data Persistence

The following data is persisted across deployments:
- Ghost content (themes, images, posts): `ghost_content` volume
- MySQL database: `ghost_mysql` volume
- ActivityPub content: `activitypub_content` volume
- Caddy certificates and config: `caddy_data` and `caddy_config` volumes

## Custom Theme

This repository includes a custom Ghost theme in the `ghost-theme` directory. The theme is automatically mounted into the Ghost container at `/var/lib/ghost/content/themes/evansims-theme`.

### Theme Development

1. Edit theme files in the `ghost-theme` directory
2. The theme uses Gulp for building CSS assets:
   ```bash
   cd ghost-theme
   npm install
   npm run build  # or: npx gulp
   ```
3. Changes will be reflected immediately in Ghost after a page refresh
4. To activate the theme, go to Ghost Admin → Settings → Design → Change theme → Advanced → Upload theme → Select "evansims-theme"

### Theme Structure
- `default.hbs` - Base template for all pages
- `index.hbs` - Homepage template
- `post.hbs` - Individual post template
- `assets/css/screen.css` - Main stylesheet
- `package.json` - Theme metadata and configuration

### Automatic Theme Updates

The Ghost container automatically updates the theme version on every deployment using a custom entrypoint script. This ensures Ghost always loads the latest theme changes without manual intervention.

When you deploy through Dokploy:
1. Push your theme changes to GitHub
2. Deploy in Dokploy
3. The theme version is automatically updated with a timestamp
4. Ghost detects the version change and reloads the theme

No manual cache clearing or version incrementing required!

## Administrative Access

The deployment includes an admin service for maintenance tasks:

```bash
# Access the admin container
docker compose exec admin bash

# Available tools in admin container:
- MySQL client with pre-configured aliases
- curl, wget for API testing
- jq for JSON processing
- vim, nano for editing
- git for repository operations

# Useful aliases:
- `mysql-root` - Connect as MySQL root user
- `mysql-ghost` - Connect to Ghost database
- `mysql-activitypub` - Connect to ActivityPub database
```

Common administrative tasks:
- Database backups and maintenance
- Debugging service connectivity
- Running migrations
- Checking logs and service health